class CartsController < ApplicationController

  def add_item
    @cart = get_cart
    item = @cart.get_item_by(cart_line_items_params[:product_id])
    item ? item.quantity += 1 : item = @cart.cart_line_items.new(cart_line_items_params)
    @cart.save
    redirect_to carts_show_path
  end

  def update_coupon_code
    @cart = get_cart

    ### business logical validates only for update_coupon_code action
    # validates_discounted_product
    if @cart.has_discounted_items?
      @cart.errors.add(:coupon_code, :discounted_product_coupon_code)
      render 'show' and return
    end

    # validates_coupon_code_exist
    if cart_params[:coupon_code].empty?
      @cart.coupon_code_id = nil
      @cart.errors.add(:coupon_code, :coupon_code_not_exist)
      render 'show' and return
    end

    # validates_coupon_code_usable
    coupon_code = CouponCode.find_by code: cart_params[:coupon_code]

    @cart.coupon_code_id = coupon_code ? coupon_code.id : nil
    unless @cart.valid_coupon_code?
      @cart.errors.add(:coupon_code, :coupon_code_not_avaiable)
      render 'show' and return
    end

    # finally it could be saved
    if @cart.save
      redirect_to carts_show_path
    else
      render 'show'
    end
  end

  def destroy_coupon_code
    @cart = get_cart
    @cart.coupon_code_id = nil
    redirect_to carts_show_path if @cart.save
  end

  def show
    @cart = get_cart
    if @cart and @cart.cart_line_items.any?
      @related_products = Product.published.find(@cart.cart_line_items.first.product_id).related_products
    else
      @related_products = Product.published.take.related_products
    end
  end

  def add_item_quantity
    @cart = get_cart
    @item = @cart.cart_line_items.find(params[:item_id])
    @item.quantity += 1
    @item.save and @cart = @item.cart #@item.cart is changed after committing @item
    respond_to do  |format|
      format.js { render 'update_cart', layout: false }
    end
  end
  
  def reduce_item_quantity
    @cart = get_cart
    @item = @cart.cart_line_items.find(params[:item_id])
    @item.quantity -= 1
    @item.quantity == 0 ? @item.destroy : @item.save and @cart = @item.cart #@item.cart is changed after committing @item

    respond_to do |f|
      if @item.quantity == 0
        f.js { render 'destroy_item', layout: false }
      else
        f.js { render 'update_cart', layout: false }
      end
    end
  end

  def destroy_item
    @cart = get_cart
    @item = @cart.cart_line_items.find(params[:item_id])
    @item.destroy
    @cart.save
    respond_to do |f|
      f.js { render layout: false }
    end
    #redirect_to carts_show_path
  end

  private

  def get_cart
    return @nav_cart if @nav_cart
    cart = Cart.find_by user_id: current_or_guest_user.id
    cart = Cart.new(user_id: current_or_guest_user.id) if cart.nil?
    cart
  end

  def cart_params
    params.require(:cart).permit(:coupon_code)
  end

  def cart_line_items_params
    params.require(:cart).permit(:cart_id, :product_id, :total_price, :quantity)
  end

end
