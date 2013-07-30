# encoding: utf-8
class OrdersController < ApplicationController
  layout 'horizontal'
  before_action :load_cart
  before_action :fetch_items, only: [:new, :back_order_new, :taobao_order_new, :create, :back_order_create, :taobao_order_create, :current]
  before_action :fetch_related_products, only: [:back_order_create, :taobao_order_create, :current]
  before_action :authenticate_user!, only: [:new, :index, :show, :create, :checkout, :cancel]
  before_action :authenticate_administrator!, only: [:back_order_new, :back_order_create, :taobao_order_new, :taobao_order_create]
  before_action :process_custom_data, only: [:return, :notify]
  skip_before_action :verify_authenticity_token, only: [:notify]

  include ::Extension::Order

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
    # FIXME, the populate doesn't work on form
    @order_form.sender = SenderInfo.new(current_user.as_json) # nil.as_json => nil
    # AnalyticWorker.delay.open_order(current_user.id, @products.map(&:name), Time.now)
  end

  # taobao order
  # - used for taobao order input
  # - transaction is completed beforehand
  # - tracking is skipped
  def taobao_order_new
    validate_cart
    @order = Order.new
    @order.build_address
  end

  def taobao_order_create
    merchant_trade_no = taobao_order_params.extract!(:merchant_trade_no)

    @order = current_or_guest_user.orders.build(taobao_order_params.except(:merchant_trade_no))

    # create line items
    @cart.keys.each do |key|
      @order.add_line_item(key, @cart[key])
    end

    # add type
    @order.kind = :taobao

    # add source
    @order.source = '淘宝'

    opts = { paymethod: 'directPay', merchant_name: 'Alipay' }.merge(merchant_trade_no)

    if @order.save and @order.complete_transaction(opts)
      empty_cart
      flash[:notice] = t('controllers.order.order_success')
      redirect_to root_path
    else
      render 'taobao_order_new'
    end
  end

  # backorder
  # - used for internal usage
  # - no transaction is issued
  # - tracking is skipped
  def back_order_new
    validate_cart
    @order = Order.new
    @order.build_address
  end

  def back_order_create
    @order = current_or_guest_user.orders.build(back_order_params)

    # create line items
    @cart.keys.each do |key|
      @order.add_line_item(key, @cart[key])
    end

    # default sender_info
    @order.sender_name = 'Huali'
    @order.sender_email = 'support@hua.li'
    @order.sender_phone = '400-001-6936'

    # jump to wait_make states
    @order.state = 'wait_make'

    if @order.kind.in?('marketing', 'customer') && @order.save
      empty_cart
      flash[:notice] = t('controllers.order.order_success')
      redirect_to root_path
    else
      render 'back_order_new'
    end
  end

  def create
    @order_form = OrderForm.new(params[:order_form])
    @order_form.user = current_or_guest_user

    # create line items
    @cart.keys.each do |key|
      @order_form.add_line_item(key, @cart[key])
    end

    if @order_form.save
      empty_cart
      update_guest if current_or_guest_user.guest?

      flash[:notice] = t('controllers.order.order_success')
      redirect_to checkout_order_path(@order)
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
    def user_order_params
      params.require(:order).permit(*normal_order_fields)
    end

    def back_order_params
      params.require(:order).permit(*back_order_fields)
    end

    def taobao_order_params
      params.require(:order).permit(*taobao_order_fields)
    end

    def taobao_order_fields
      back_order_fields.concat [:merchant_trade_no]
    end

    def back_order_fields
      normal_order_fields.concat [:kind, :ship_method_id, :delivery_date,
                                  :adjustment, :bypass_region_validation,
                                  :bypass_date_validation]
    end

    def normal_order_fields
      [
        :sender_name, :sender_email, :sender_phone,
        :coupon_code, :gift_card_text, :special_instructions,
        :source, :expected_date,
        address_attributes: [
           :fullname, :phone, :province_id,
           :city_id, :area_id, :post_code,
           :address]
      ]
    end

    def empty_cart
      session[:order_id] = @order.id
      cookies.delete :cart
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
      if @cart.blank? || @cart.all? { |k, v| v.to_i <= 0 }
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
