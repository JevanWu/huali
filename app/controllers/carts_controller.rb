class CartsController < ApplicationController
  def create
    @cart = Cart.new(cart_params)
    redirect_to 'show' if @cart.save
  end
  def show
    @carts = Cart.where(user_id: current_user.id)
    @product = Product.published.find(@carts.first.product_id)
    @related_products = @product.related_products
  end




  def cart_params
      params.require(:cart).permit(:user_id, :product_id, :quantity, :price)
  end
end
