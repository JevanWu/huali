# encoding: utf-8
class OrdersController < ApplicationController
  before_action :fetch_related_products, only: [:back_order_create, :taobao_order_create, :current, :apply_coupon]
  before_action :authenticate_user!, only: [:new, :index, :show, :create, :checkout, :cancel]
  before_action :authenticate_administrator!, only: [:back_order_new, :back_order_create, :taobao_order_new, :taobao_order_create]
  before_action :process_custom_data, only: [:return, :notify]
  skip_before_action :verify_authenticity_token, only: [:notify]
  before_action :check_back_order_permission, only: [:back_order_new, :taobao_order_new, :back_order_create, :taobao_order_create]

  def index
    @orders = current_or_guest_user.orders
  end

  def show
    orders = current_or_guest_user.orders
    if orders.find_by_id(params[:id]).nil?
      flash[:alert] = t('controllers.order.no_orders_for_you')
      redirect_to :root
    else
      @order = orders.full_info(params[:id])
    end
  end

  def new
    validate_cart
    @order_form = OrderForm.new
    @order_form.address = ReceiverInfo.new
    @order_form.sender = SenderInfo.new(current_user.as_json) # nil.as_json => nil
    AnalyticWorker.delay.open_order(current_user.id, @products.map(&:name), Time.now)
  end

  # taobao order
  # - used for taobao order input
  # - transaction is completed beforehand
  # - tracking is skipped
  def taobao_order_new
    validate_cart
    @order_admin_form = OrderAdminForm.new({source: '淘宝', kind: 'taobao'})
    @order_admin_form.sender = SenderInfo.new
    @order_admin_form.address = ReceiverInfo.new
  end

  # backorder
  # - used for internal usage
  # - no transaction is issued
  # - tracking is skipped
  def back_order_new
    validate_cart
    @order_admin_form = OrderAdminForm.new({kind: 'marketing'})
    @order_admin_form.address = ReceiverInfo.new
  end

  def taobao_order_create
    process_admin_order('taobao_order_new') do |record|
      record.state = 'wait_make'
    end
  end

  def back_order_create
    opts = { paymethod: 'directPay',
             merchant_name: 'Alipay',
             merchant_trade_no: params[:merchant_trade_no]}

    process_admin_order('back_order_new') do |record|
      record.complete_transaction(opts)
    end
  end


  def create
    @order_form = OrderForm.new(params[:order_form])
    @order_form.user = current_or_guest_user

    update_coupon_code(@order_form.coupon_code)

    # create line items
    @cart.items.each do |item|
      @order_form.add_line_item(item.product_id, item.quantity)
    end

    if @order_form.save
      empty_cart
      store_order_id(@order_form.record)

      update_guest if current_or_guest_user.guest?

      flash[:notice] = t('controllers.order.order_success')
      redirect_to checkout_order_path(@order_form.record)
    else
      render 'new'
    end
  end

  def checkout
    @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CMBC']
    if params[:id]
      @order = current_or_guest_user.orders.find_by_id(params[:id])
      if @order.blank?
        flash[:alert] = t('controllers.order.order_not_exist')
        redirect_to :root
      end
    else
      @order = Order.find_by_id(params[:id] || session[:order_id])
      if @order.blank?
        flash[:alert] = t('controllers.order.no_items')
        redirect_to :root
      end
    end
  end

  def gateway
    @order = Order.find_by_id(params[:id] || session[:order_id])

    # params[:pay_info] is mixed with two kinds of info - pay method and merchant_name
    # these two are closed bound together
    payment_opts = process_pay_info(params[:pay_info])
    transaction = @order.generate_transaction payment_opts
    transaction.start
    redirect_to transaction.request_path
  end

  def return
    begin
      transaction = Transaction.find_by_identifier @custom_id
      if transaction.return(request.query_string)
        @order = transaction.order
        render 'success'
      else
        @order = transaction.order
        render 'failed', status: 400
      end
    rescue
      render 'failed', status: 400
    end
  end

  def notify
    transaction = Transaction.find_by_identifier @custom_id
    begin
      if transaction.notify(request.raw_post)
        render text: "success"
      else
        render text: "failed", status: 400
      end
    rescue
      render text: "failed", status: 400
    end
  end

  def current ; end

  def apply_coupon
    coupon = Coupon.find_by_code(params[:coupon_code])

    update_coupon_code(params[:coupon_code]) if @cart

    render :current
  end

  def cancel
    @order = current_or_guest_user.orders.find_by_id(params[:id])
    if @order.cancel
      flash[:notice] = t('controllers.order.cancel_success')
    else
      flash[:alert] = t('controllers.order.cancel_failed')
    end
    redirect_to orders_path
  end

  private

    def check_back_order_permission
      current_admin_ability.authorize! :record_back_order, Order
    end

    def process_admin_order(template)
      @order_admin_form = OrderAdminForm.new(params[:order_admin_form])
      @order_admin_form.sender ||= SenderInfo.new({
                                                  name: 'Huali',
                                                  email: 'support@hua.li',
                                                  phone: '400-001-6936'
                                                })
      @order_admin_form.user = current_or_guest_user

      # create line items
      @cart.items.each do |item|
        @order_admin_form.add_line_item(item.product_id, item.quantity)
      end

      success = @order_admin_form.save do |record|
        yield(record) if block_given?
      end

      if success
        empty_cart
        store_order_id(@order_admin_form.record)

        flash[:notice] = t('controllers.order.order_success')
        redirect_to root_path
      else
        render template
      end
    end

    def store_order_id(record)
      session[:order_id] = record.id
    end

    def update_guest
      # need an object to hold the user instance
      guest = guest_user
      guest.email = @order.sender_email
      guest.phone = @order.sender_phone
      guest.name = @order.sender_name
      guest.save
      # FIXME it is possible, the email exists in User
      # this guest is registered before
    end

    def validate_cart
      # - no line items present
      # - zero quantity
      if @cart.blank? || @cart.items.any? { |item| item.quantity.to_i <= 0 }
        flash[:alert] = t('controllers.order.no_items')
        redirect_to :root
      end
    end

    def process_custom_data
      @custom_id = request.params["custom_id"]
    end

    def process_pay_info(pay_info)
      case pay_info
      when 'directPay'
        { paymethod: 'directPay', merchant_name: 'Alipay' }
      when 'paypal'
        { paymethod: 'paypal', merchant_name: 'Paypal' }
      else
        { paymethod: 'bankPay', merchant_name: pay_info }
      end
    end

end
