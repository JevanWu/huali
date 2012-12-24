class OrdersController < ApplicationController
  layout 'order'
  before_filter :load_cart

  def index
    @orders = Order.all
  end

  def show

  end

  def new
    @order = Order.new
  end

  def create
    order = Order.new(params[:order])

    # TODO check against invalid cart
    # - no line items present
    # - zero quantity

    # create line items
    @cart.keys.each do |key|
      order.add_line_item(key, @cart[key])
    end

    if order.save!
      session[:order_id] = order.id
      cookies.delete :cart

      flash[:notice] = "Successfully created order and addresses."
      redirect_to checkout_order_path
    else
      render :action => 'new'
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
    parse_pay_info
    transaction = @order.generate_transaction(@options)

    gateway = Billing::Alipay::Gateway.new transaction.to_alipay
    redirect_to gateway.purchase_path
  end

  def return
  end

  def notify
  end

  def current
    @products = []
    @cart.keys.each do |key|
      if product = Product.find_by_id(key)
        product[:quantity] = @cart[key]
        @products.push product
      end
    end
  end

  private

    def parse_pay_info
      @options = case params[:pay_info]
      when 'directPay'
        { paymethod: params[:pay_info], merchant_name: '' }
      when 'paypal'
        { paymethod: params[:pay_info], merchant_name: '' }
      else
        { paymethod: 'bankPay', merchant_name: params[:pay_info]}
      end
    end

    def load_cart
      begin
        @cart = JSON.parse(cookies['cart']).select {|k, v| k =~ /^\d+$/}
      rescue
        @cart = {}
      end
    end
end
