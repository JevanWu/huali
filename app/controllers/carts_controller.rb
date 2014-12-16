class CartsController < ApplicationController
  def create
    @cart = Cart.where(user_id: cart_params[:user_id]).first
    @cart = Cart.new(user_id: cart_params[:user_id]) if @cart.nil?
    @cart.cart_line_items.new(product_id: cart_params[:product_id],
                         quantity: cart_params[:quantity],
                         price: cart_params[:price])
    @cart.total_price = @cart.cart_line_items.map(&:price).inject(:+)
    redirect_to carts_show_path if @cart.save
  end
  def show
    @cart = Cart.where(user_id: current_user.id).first
    if @cart.present?
      @product = Product.published.find(@cart.cart_line_items.first.product_id)
      @related_products = @product.related_products
    end
  end


  def cart_params
      params.require(:cart).permit(:user_id, :product_id, :quantity, :price)
  end
end
