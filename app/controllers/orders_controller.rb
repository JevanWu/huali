class OrdersController < ApplicationController
  layout 'horizontal'
  before_filter :load_cart
  before_filter :fetch_items, only: [:new, :create, :current]

  # authorize_resource

  def index
    @orders = current_or_guest_user.orders
  end

  def show
    @order = current_or_guest_user.orders.full_info(params[:id])
  end

  def new
    @order = Order.new
    @order.build_address
  end

  def create
    validate_cart

    @order = current_or_guest_user.orders.build(params[:order])

    # create line items
    @cart.keys.each do |key|
      @order.add_line_item(key, @cart[key])
    end

    if @order.save
      session[:order_id] = @order.id
      cookies.delete :cart

      flash[:notice] = "Successfully created order and addresses."
      redirect_to checkout_order_path
    else
      render 'new'
    end
  end

  def checkout
    @order = Order.find_by_id(session[:order_id])
    @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CMBC']

    if @order.blank?
      flash[:alert] = "No items in the cart, please add items first."
      redirect_to :root
    end
  end

  def gateway
    @order = Order.find_by_id(session[:order_id])

    # TODO make params[:pay_info] more clear
    # currently it is mixed with two kinds of inf - pay method and merchant_name
    # they should be separated
    transaction = @order.generate_transaction params[:pay_info]
    redirect_to transaction.request_process
  end

  def return
    transaction = Transaction.return(request.query_string)
    if transaction
      @order = transaction.order
      render 'success'
    else
      render 'failed'
    end
  end

  def notify
    if Transaction.notify(request.raw_post)
      render :text => "success"
    else
      render :text => "failed"
    end
  end

  def current
  end

  private

    def validate_cart
      # TODO check against invalid cart
      # - no line items present
      # - zero quantity
      true
    end

    def load_cart
      begin
        @cart = JSON.parse(cookies['cart']).select {|k, v| k =~ /^\d+$/}
      rescue
        @cart = {}
      end
    end

    def fetch_items
      @products = []
      @cart.keys.each do |key|
        if product = Product.find_by_id(key)
          product[:quantity] = @cart[key]
          @products.push product
        end
      end
    end
end
