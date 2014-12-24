class CartsController < ApplicationController

  def create
    @cart = get_cart
    item = @cart.get_item_by(cart_line_items_params[:product_id])
    if item
      item.quantity += 1
      item.save
    else
      @cart.cart_line_items.new(cart_line_items_params)
    end
    @cart.total_price = @cart.calculate_total_price
    redirect_to carts_show_path if @cart.save
  end

  def update_coupon_code
    @cart = get_cart
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
      redirect_to carts_show_path
    end
  end
  def show
    @cart = get_cart
    if @cart and @cart.cart_line_items.any?
      @product = Product.published.find(@cart.cart_line_items.first.product_id)
      @related_products = @product.related_products
    end
  end
  
  def item_decrease
    @cart = get_cart
    item = @cart.cart_line_items.find(params[:item_id])
    item.quantity -= 1
    if item.quantity == 0
      item.destroy
    else
      item.save
    end
    @cart.total_price = @cart.calculate_total_price
    @cart.save
    redirect_to carts_show_path
  end

  def item_increase
    @cart = get_cart
    item = @cart.cart_line_items.find(params[:item_id])
    item.quantity += 1
    item.save
    @cart.total_price = @cart.calculate_total_price
    @cart.save
    redirect_to carts_show_path
  end

  def item_destroy
    @cart = get_cart
    item = @cart.cart_line_items.find(params[:item_id])
    item.destroy
    redirect_to carts_show_path
  end

  private

  def get_cart
    cart = Cart.find_by user_id: current_or_guest_user.id
    if cart.nil?
      cart = Cart.new(cart_params) 
      cart.user_id = current_or_guest_user.id
    end
    cart
  end
  def cart_params
      params.require(:cart).permit(:user_id, :total_price, :coupon_code_id)
  end
  def cart_line_items_params
    params.require(:cart).permit(:cart_id, :product_id, :price, :quantity)
  end

end
