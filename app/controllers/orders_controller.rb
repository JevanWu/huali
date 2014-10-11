# encoding: utf-8
require 'json'
require 'digest'
class OrdersController < ApplicationController
  before_action :justify_wechat_agent, only: [:index, :current, :checkout, :gateway, :new, :create]
  before_action :fetch_related_products, only: [:back_order_create, :channel_order_create, :current, :apply_coupon]
  before_action :signin_with_openid, only: [:new, :index]
  before_action :authenticate_user!, only: [:new, :index, :show, :create, :checkout, :cancel, :edit_gift_card, :update_gift_card]
  before_action :authenticate_administrator!, only: [:back_order_new, :back_order_create, :channel_order_new, :channel_order_create]
  #before_action :fetch_transaction, only: [:return, :notify]
  skip_before_action :verify_authenticity_token, only: [:notify]
  before_action :authorize_to_record_back_order, only: [:back_order_new, :channel_order_new, :back_order_create, :channel_order_create]
  before_action :validate_cart, only: [:new, :channel_order_new, :back_order_new, :create, :back_order_create, :channel_order_create]

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
    @order_form = OrderForm.new(coupon_code: cookies[:coupon_code])
    @order_form.address = ReceiverInfo.new
    @order_form.sender = SenderInfo.new(current_user.as_json) # nil.as_json => nil

    @coupon_code = @card.present? && @card.coupon.present? ? @card.coupon : ""
  end

  # channel order
  # - used for channel order input
  # - transaction is completed beforehand
  # - tracking is skipped
  def channel_order_new
    @order_admin_form = OrderAdminForm.new(source: '淘宝',
                                           kind: 'taobao',
                                           coupon_code: cookies[:coupon_code])
    @order_admin_form.sender = SenderInfo.new
    @order_admin_form.address = ReceiverInfo.new
  end

  # backorder
  # - used for internal usage
  # - transaction is issued for tracking paymenthod
  # - tracking is skipped
  def back_order_new
    @offline_order_form = OfflineOrderForm.new(kind: 'offline', coupon_code: cookies[:coupon_code])
    @offline_order_form.address = ReceiverInfo.new
  end

  def channel_order_create
    opts = { paymethod: 'alipay',
             merchant_name: 'Alipay',
             merchant_trade_no: params[:merchant_trade_no]}

    process_admin_order('channel_order_new') do |record|
      record.complete_transaction(opts)
    end
  end

  def back_order_create # 线下店订单录入
    process_admin_order('back_order_new') do |record|
      record.state = record.ship_method_id? ? 'wait_make' : 'completed'
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

    if !@order_form.user.name.present?
      redirect_to settings_profile_path, flash: {success: "请填写您的姓名"} and return
    end

    if @order_form.save
      empty_cart
      delete_address_select_cookies

      OrderDiscountPolicy.new(@order_form.record).apply
      store_order_id(@order_form.record)

      update_guest if current_or_guest_user.guest?

      if @order_form.record.total <= 0
        @order_form.record.skip_payment

        if cookies[:in_limited_promotion]
          flash[:notice] = t('controllers.order.success_to_get_promo_product')
          flash[:limited_promo_result] = 1
        else
          flash[:notice] = t('controllers.order.order_success')
        end
        redirect_to order_path(@order_form.record)
      else
        if cookies[:in_limited_promotion]
          flash[:alert] = t('controllers.order.fail_to_get_promo_product')
          flash[:limited_promo_result] = 0
        else
          flash[:notice] = t('controllers.order.order_success')
        end

        if @use_wechat_agent
          redirect_to checkout_order_path(@order_form.record, showwxpaytitle: 1)
        else
          redirect_to checkout_order_path(@order_form.record)
        end
      end
    else
      set_address_select_cookies
      render 'new'
    end
  end

  def edit_gift_card
    order = Order.find params[:id]
    if order.user == current_user
      @order = order
    else
      redirect_to root_path, flash: { success: t('views.order.gift_card.not_allowed_to_edit') }
    end
  end

  def update_gift_card
    order = Order.find params[:id]

    if ['generated', 'wait_check', 'wait_make'].include?(order.state) # Orders after make cannot be updated!
      order.update(gift_card_params)
      redirect_to orders_path, flash: { success: t('views.order.gift_card.updated_successfully') }
    else
      redirect_to orders_path, flash: { success: t('views.order.gift_card.cannot_edit') }
    end
  end

  def checkout
    @order = current_or_guest_user.orders.find_by_id(params[:id]) if params[:id]
    @order ||= Order.find_by_id(session[:order_id])

    if @order.blank?
      flash[:alert] = t('controllers.order.order_not_exist')
      redirect_to :root and return
    else
      set_wechat_pay_params(@order, request.remote_ip) if @use_wechat_agent
    end

    @cart = Cart.new(@order.line_items,
                     @order.coupon_code_record.try(:code),
                     @order.adjustment)
  end

  def gateway
    @order = Order.find_by_id(params[:id] || session[:order_id])
    # params[:pay_info] is mixed with two kinds of info - pay method and merchant_name
    # these two are closed bound together
    payment_opts = process_paymethod(params[:paymethod])
    transaction = @order.generate_transaction payment_opts.merge(client_ip: request.remote_ip), params[:use_huali_point]
    transaction.start
    if transaction.amount == 0
      flash[:alert] = t('views.order.paid')
      HualiPointService.minus_expense_point(transaction.user, transaction)
      transaction.complete
      redirect_to orders_path
    else
      redirect_to transaction.request_path
    end
  end

  def fetch_transaction
    begin
      # Alipay and wechat pay use parameter "out_trade_no" to store transaction_id, while paypay use parameter "custom"
      @transaction = Transaction.find_by_identifier!(params["out_trade_no"] || params["custom"])
      @order = @transaction.order
    rescue ActiveRecord::RecordNotFound
      raise ArgumentError, "Parameter out_trade_no is not right"
    end
  end

  private :fetch_transaction

  def return
    fetch_transaction
    user = @transaction.order.user
    if @transaction.return(request.query_string)
      HualiPointService.minus_expense_point(user, @transaction)
      render 'success'
    else
      @transaction.failure if @transaction.state == "processing"
      render 'failed', status: 400
    end
  end

  def paypal_return
    render 'success_paypal'
  end

  def notify
    fetch_transaction
    query = request.raw_post.present? ? request.raw_post : request.query_string # wechat use method 'get' to send notify request
    user = @transaction.order.user
    if @transaction.notify(query)
      HualiPointService.minus_expense_point(user, @transaction)
      render text: "success"
    else
      @transaction.failure if @transaction.state == "processing"
      render text: "failed", status: 400
    end
  end

  def wechat_notify
    bill = Billing::Base.new(:notify, nil, params.merge(client_ip: request.remote_ip))
    if bill.success?
      render text: "success"
    else
      render text: "failed"
    end
  end

  def current
    if params[:coupon_code].present? && params[:product_ids].present?
      coupon_code = CouponCode.find_by_code!(params[:coupon_code])
      products = Product.where(slug: params[:product_ids].split(',')).to_a

      if !coupon_code.usable? || products.any? { |p| p.count_on_hand <=0 }
        flash[:alert] = t('controllers.order.products_sold_out')
        redirect_to root_path and return
      end

      cookies[:coupon_code] = coupon_code.to_s
      cookies['cart'] = products.reduce({}) { |memo, p| memo[p.id] = 1; memo }.to_json


      load_cart
    end
    @wechat_oauth_url = (@use_wechat_agent && current_user.nil?) ? Wechat::WechatHelper.wechat_oauth_url(:code, new_order_url) : new_order_url
  end

  def apply_coupon
    coupon_code = CouponCode.find_by_code(params[:coupon_code].try(:downcase))

    update_coupon_code(params[:coupon_code].try(:downcase)) if @cart

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

  def logistics
    @order = current_or_guest_user.orders.find_by_id(params[:id])
  end

  def wechat_warning
    warning = { error_type: params[:xml][:ErrorType] || "", description: parameters[:Description] || "", alarm_content: parameters[:AlarmContent] || "" }
    Notify.delay.wechat_warning(warning, "jevan@hua.li", "ryan@hua.li", "ella@hua.li")
    render text: "success"
  end

  def wechat_feedback
    render text: "success"
  end

  private

    def authorize_to_record_back_order
      current_admin_ability.authorize! :record_back_order, Order
    end

    def process_admin_order(template)
      if params[:offline_order_form][:ship_method_id].blank?
        params[:offline_order_form][:bypass_date_validation] = true
        params[:offline_order_form][:bypass_region_validation] = true
        params[:offline_order_form][:bypass_product_validation] = true

        params[:offline_order_form][:expected_date] = Date.current.to_s
        params[:offline_order_form][:delivery_date] = Date.current.to_s
        params[:offline_order_form][:address] = { fullname: 'Huali', phone: '400-087-8899', address: '线下店自提', province_id: 33, city_id: 347 }
      end

      @offline_order_form = OfflineOrderForm.new(params[:offline_order_form])

      update_coupon_code(@offline_order_form.coupon_code)

      @offline_order_form.sender ||= SenderInfo.new({ name: 'Huali', email: 'support@hua.li', phone: '400-087-8899' })
      @offline_order_form.user = current_or_guest_user

      # create line items
      @cart.items.each do |item|
        @offline_order_form.add_line_item(item.product_id, item.quantity)
      end

      success = @offline_order_form.save do |record|
        yield(record) if block_given?
      end

      if success
        empty_cart

        OrderDiscountPolicy.new(@offline_order_form.record).apply
        store_order_id(@offline_order_form.record)

        opts = { paymethod: params[:offline_order_form][:paymethod],
                 merchant_name: 'Alipay' }
        transaction = @offline_order_form.record.reload.generate_transaction(opts)
        transaction.update_column(:state, 'completed')

        if @offline_order_form.record.state == 'completed'
          ErpWorker::ImportOrder.perform_async(@offline_order_form.record.id)
        end

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

    def process_paymethod(paymethod)
      case paymethod
      when 'alipay'
        { paymethod: 'alipay', merchant_name: 'Alipay' }
      when 'paypal'
        { paymethod: 'paypal', merchant_name: 'Paypal' }
      when 'wechat'
        { paymethod: 'wechat', merchant_name: 'Tenpay' }
      end
    end

    def set_wechat_pay_params(order, client_ip)
      @appid = Wechat::ParamsGenerator.get_appid
      @timestamp = Wechat::ParamsGenerator.get_timestamp
      @nonce_str = Wechat::ParamsGenerator.get_nonce_str
      @package = Wechat::ParamsGenerator.get_package(order, client_ip)
      @sign_type = Wechat::ParamsGenerator.get_signtype
      @sign = Wechat::ParamsGenerator.get_sign(@nonce_str, @package, @timestamp)
    end

    def gift_card_params
      params.require(:order).permit(:gift_card_text, :special_instructions)
    end

    def set_address_select_cookies
      cookies[:address_province_id] = @order_form.address.province_id
      cookies[:address_city_id] = @order_form.address.city_id
      cookies[:address_area_id] = @order_form.address.area_id
    end

    def delete_address_select_cookies
      cookies.delete :address_province_id
      cookies.delete :address_city_id
      cookies.delete :address_area_id
    end
end
