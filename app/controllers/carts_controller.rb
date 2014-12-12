class CartsController < ApplicationController
  def create
    @cart = Cart.new(cart_params)
    redirect_to 'show' if @cart.save
  end
  def show
    @cart = Cart.find(Cart.where(user_id: current_user.id))
  end




  def cart_params
      params.require(:cart).permit(:user_id, :product_id, :quantity, :price)
  end
end
