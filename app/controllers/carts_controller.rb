class CartsController < ApplicationController

  def create
    @cart = Cart.where(user_id: current_or_guest_user.id).first
    if @cart.nil?
      @cart = Cart.new(cart_params) 
      @cart.user_id = current_or_guest_user.id
    end
    @cart.cart_line_items.new(cart_line_items_params)
    @cart.total_price = @cart.calculate_total_price
    redirect_to carts_show_path if @cart.save
  end
  def update_coupon_code
    @cart = Cart.where(user_id: current_user.try(:id)).first
    coupon_codes = CouponCode.where code: cart_params[:coupon_code_id]
    @cart.coupon_code_id = coupon_codes.first.id if coupon_codes.any?
    if @cart.coupon_code and @cart.valid_coupon_code?
      @cart.total_price = @cart.calculate_total_price
      redirect_to carts_show_path if @cart.save
    else
      if @cart.get_line_items.any? { |item| item.product.discount? }
        @cart.errors.add(:coupon_code, :discounted_product_coupon_code)
      end
      @cart.errors.add(:coupon_code, :coupon_code_not_avaiable)
      render carts_show_path
    end
  end
  def show
    @cart = Cart.where(user_id: current_or_guest_user.id).first
    if @cart and @cart.cart_line_items.any?
      @product = Product.published.find(@cart.cart_line_items.first.product_id)
      @related_products = @product.related_products
    end
  end

  private
  def cart_params
      params.require(:cart).permit(:user_id, :total_price, :coupon_code_id)
  end
  def cart_line_items_params
    params.require(:cart).permit(:cart_id, :product_id, :price, :quantity)
  end

end
