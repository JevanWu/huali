class OrdersController < ApplicationController
  layout 'horizontal'
  before_filter :load_cart
  before_filter :fetch_items, only: [:new, :create, :current]
  before_filter :fetch_related_products, only: [:new, :current]
  before_filter :authenticate_user!, only: [:new, :index, :show, :create, :checkout, :cancel]
  before_filter :process_custom_data, only: [:return, :notify]
  skip_before_filter :verify_authenticity_token, only: [:notify]

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
    @order = Order.new
    @order.build_address
    populate_sender_info unless current_or_guest_user.guest?

    Analytics.track(
      user_id: current_user.id,
      event: 'Opened Order Form',
      properties: {
        category: 'order',
        products: @cart.keys,
        # FIXME added property to calculate user visits before submit form
        # visited_pages_count: 2
      },
      context: {
        'Google Analytics' => {
          clientId: cookies['ga_client_id']
        }
      }
    )
  end

  def create
    @order = current_or_guest_user.orders.build(params[:order])

    # create line items
    @cart.keys.each do |key|
      @order.add_line_item(key, @cart[key])
    end

    if @order.save
      empty_cart
      update_guest if current_or_guest_user.guest?

      flash[:notice] = t('controllers.order.order_success')

      Analytics.track(
        user_id: @order.user_id,
        event: 'Filled Order Form',
        properties: {
          category: 'order',
          identifier: @order.identifier,
          revenue: @order.payment_total,
          coupon_code: @order.coupon_code,
          province: @order.province_name,
          city: @order.city_name,
          source: @order.source,
          products: @order.product_names,
          categories: @order.category_names,
          paymethod: @order.paymethod
        },
        timestamp: @order.created_at,
        context: {
          'Google Analytics' => {
            clientId: cookies['ga_client_id']
          }
        }
      )

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

        Analytics.track(
          user_id: @order.user_id,
          event: 'Completed Order Payment',
          properties: {
            category: 'order',
            identifier: @order.identifier,
            revenue: @order.payment_total,
            coupon_code: @order.coupon_code,
            province: @order.province_name,
            city: @order.city_name,
            source: @order.source,
            products: @order.product_names,
            categories: @order.category_names,
            paymethod: @order.paymethod
          },
          timestamp: @order.created_at,
          context: {
            'Google Analytics' => {
              clientId: cookies['ga_client_id']
            }
          }
        )

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
    def empty_cart
      session[:order_id] = @order.id
      cookies.delete :cart
    end

    def populate_sender_info
      @order.sender_email = current_user.try(:email)
      @order.sender_name = current_user.try(:name)
      @order.sender_phone = current_user.try(:phone)
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
        flash[:alert] = t('controllers.order.checkout.no_items')
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
