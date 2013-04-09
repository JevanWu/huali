class OrdersController < ApplicationController
  layout 'horizontal'
  before_filter :sub_request
  before_filter :load_cart
  before_filter :fetch_items, only: [:new, :create, :current]
  before_filter :authenticate_user!, only: [:new, :index, :show, :create, :checkout, :cancel]
  before_filter :process_custom_data, only: [:return, :notify]

  include ::Extension::Order

  # authorize_resource

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
      @order = Order.last
      @order = Order.find_by_id(params[:id] || session[:order_id])
      if @order.blank?
        flash[:alert] = t('controllers.order.no_items')
        redirect_to :root
      end
    end
  end

  def gateway
    @order = Order.find_by_id(params[:id] || session[:order_id])

    # TODO make params[:pay_info] more clear
    # currently it is mixed with two kinds of inf - pay method and merchant_name
    # they should be separated

    transaction = @order.generate_transaction params[:pay_info]
    transaction.start
    redirect_to transaction.request_path
  end

  def return
    # @customdata['identifier']
    # @customdata['paymethod']

    begin
      transaction = Transaction.find_by_identifier @customdata['identifier']
      if transaction.return(request.query_string)
        @order = transaction.order
        render 'success'
      else
        render 'failed', layout: 'layouts/error'
      end
    rescue
      render 'failed', layout: 'layouts/error', status: 400
    end
  end

  def notify
    transaction = Transaction.find_by_identifier @customdata['identifier']
    begin
      if transaction.notify(request.raw_post)
        render text: "success"
      else
        render 'failed', layout: 'layouts/error'
      end
    rescue
      render 'failed', layout: 'layouts/error', status: 400
    end
  end

  def current
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
      customdata = request.params["customdata"]
      @customdata = JSON.parse URI.unescape(customdata) if customdata
    end

    def sub_request
      request.params = {"customdata"=>"%7B%22paymethod%22:%22directPay%22,%22identifier%22:%22TRd1304090001%22%7D",
                        "discount"=>"0.00",
                        "payment_type"=>"1",
                        "subject"=>"x1,",
                        "trade_no"=>"2013040939016216",
                        "buyer_email"=>"jordan0571@163.com",
                        "gmt_create"=>"2013-04-09 16:41:08",
                        "notify_type"=>"trade_status_sync",
                        "quantity"=>"1",
                        "out_trade_no"=>"TRd1304090001",
                        "seller_id"=>"2088801670489935",
                        "notify_time"=>"2013-04-09 16:42:07",
                        "trade_status"=>"TRADE_SUCCESS",
                        "is_total_fee_adjust"=>"N",
                        "total_fee"=>"0.01",
                        "gmt_payment"=>"2013-04-09 16:42:07",
                        "seller_email"=>"tzgbusiness@gmail.com",
                        "price"=>"0.01",
                        "buyer_id"=>"2088002205666166",
                        "notify_id"=>"d7cd14d08af6f9a882bd0de63cdc0f5801",
                        "use_coupon"=>"N",
                        "sign_type"=>"MD5",
                        "sign"=>"df96f48e77b917970b2c82980bf4cd59"}
    end
end
