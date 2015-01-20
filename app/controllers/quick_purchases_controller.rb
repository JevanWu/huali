class QuickPurchasesController < ApplicationController

  def new_address
    @quick_purchase_form = QuickPurchaseForm.new
    @quick_purchase_form.sender = SenderInfo.new
    @quick_purchase_form.address = ReceiverInfo.new
  end

  def create_address
    @quick_purchase_form = QuickPurchaseForm.new(params[:quick_purchase_form])
    if @quick_purchase_form.sender.valid? and @quick_purchase_form.address.valid?
      session[:quick_purchase_form] = @quick_purchase_form
      redirect_to products_quick_purchase_path, notice: "地址已添加"
    else
      redirect_to new_address_quick_purchase_path
    end
    #@quick_purchase_form.user = current_or_guest_user
    #@quick_purchase_form.kind = :quick_purchase
  end

  def products
    # validate quick_qurchase_form
    unless session[:quick_purchase_form]
      redirect_to new_address_quick_purchase_path, notice: "请先填写地址" 
      return 
    end

    @cart_cookies = cookies[:cart] ? JSON.parse(cookies[:cart]) : nil

    expected_date = session[:quick_purchase_form].expected_date.to_s
    area_id = session[:quick_purchase_form].address.area_id.to_s
    product_ids_regin = ( DefaultRegionRule.get_product_ids_by(area_id) | LocalRegionRule.get_product_ids_by(area_id) )
    product_ids_date = ( DefaultDateRule.get_product_ids_by(expected_date) | LocalDateRule.get_product_ids_by(expected_date) )
    product_ids = product_ids_regin & product_ids_date

    @products = Product.published.where("id IN (?) and count_on_hand > 0", product_ids).page(params[:page]).per(4).order_by_priority
  end

  def create_order
    quick_purchase_form = session[:quick_purchase_form]
    quick_purchase_form.user = current_or_guest_user

    cart_cookies = JSON.parse(cookies[:cart]) 
    cart_cookies.each do |product_id, quantity|
      quick_purchase_form.add_line_item(product_id, quantity)
    end

    if quick_purchase_form.save
      empty_quick_purchase
      empty_cart
      redirect_to checkout_order_path(quick_purchase_form.record)  
    end
  end

  private
  def empty_quick_purchase
    session.delete(:quick_purchase_form)
  end
  def empty_cart
    cookies.delete :cart
    cookies.delete :coupon_code
  end

end
