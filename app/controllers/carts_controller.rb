class CartsController < ApplicationController

  def create
    @cart = Cart.where(user_id: cart_params[:user_id]).first
    @cart = Cart.new(cart_params) if @cart.nil?
    @cart.cart_line_items.new(cart_line_items_params)
    @cart.total_price = @cart.cart_line_items.map(&:price).inject(:+)
    redirect_to carts_show_path if @cart.save
  end
  def update_coupon_code
    @cart = Cart.where(user_id: current_user.try(:id)).first

    if @cart.coupon_code && !@cart.valid_coupon?
      if @cart.get_line_items.any? { |item| item.product.discount? }
        @cart.errors.add(:coupon_code, :discounted_product_coupon_code)
      else
        @cart.errors.add(:coupon_code, :coupon_code_not_avaiable)
      end
      render carts_show_path
    else
      if @cart.update(cart_params)
        redirect_to carts_show_path
      else
        render carts_show_path
      end
    end
  end
  def show
    @cart = Cart.where(user_id: current_user.id).first
    if @cart.present?
      @product = Product.published.find(@cart.cart_line_items.first.product_id)
      @related_products = @product.related_products
    end
  end


  private
  def cart_params
      params.require(:cart).permit(:user_id, :total_price, :coupon_code)
  end
  def cart_line_items_params
    params.require(:cart).permit(:cart_id, :product_id, :price, :quantity)
  end

end
