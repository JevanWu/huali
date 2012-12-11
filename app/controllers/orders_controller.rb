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
    @order = Order.new(params[:order])
    # @cart.keys.each do |key|
      # @order.add_line_item(key, @cart[key])
    # end

    if @order.save!
      flash[:notice] = "Successfully created order and addresses."
      redirect_to :home
    else
      render :action => 'new'
    end

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

    def load_cart
      begin
        @cart = JSON.parse(cookies['cart']).select {|k, v| k =~ /^\d+$/}
      rescue
        @cart = {}
      end
    end
  end
end
