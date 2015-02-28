class QuickPurchasesController < ApplicationController
  before_action :session_quick_purchase_exist?, only: [ :products, :create_order, :update_products ]
  after_action :empty_cart, only: [ :create_address ]

  respond_to :html, :js

  def new_address
    @quick_purchase_form = QuickPurchaseForm.new
    @quick_purchase_form.address = ReceiverInfo.new
    @quick_purchase_form.sender = SenderInfo.new(name: current_user.try(:name) || "",
                                                 phone: current_user.try(:phone) || "",
                                                 email: current_user.try(:email) || "")
  end

  def create_address
    @quick_purchase_form = QuickPurchaseForm.new(params[:quick_purchase_form])
    @quick_purchase_form.expected_date = 3.days.from_now.strftime("%a, %e %b %Y")
    @quick_purchase_form.kind = :quick_purchase
    if @quick_purchase_form.sender.valid? and @quick_purchase_form.address.valid?
      session[:quick_purchase_form] = @quick_purchase_form
      redirect_to products_quick_purchase_path, notice: "地址已添加"
    else
      render 'new_address'
    end
  end

  def products
    if params[:quick_purchase_form]
      unless session[:quick_purchase_form].expected_date == Date.parse(params[:quick_purchase_form][:expected_date])
        empty_cart 
        session[:quick_purchase_form].expected_date = Date.parse(params[:quick_purchase_form][:expected_date])
      end
    end

    @quick_purchase_form = session[:quick_purchase_form]
    @cart_cookies = cookies[:cart] ? JSON.parse(cookies[:cart]) : nil

    expected_date = @quick_purchase_form.expected_date
    area_id = @quick_purchase_form.address.area_id
    product_ids_regin = ( DefaultRegionRule.get_product_ids_by(area_id) | LocalRegionRule.get_product_ids_by(area_id) )
    product_ids_date = ( DefaultDateRule.get_product_ids_by(expected_date) | LocalDateRule.get_product_ids_by(expected_date) )
    product_ids = ( product_ids_regin & product_ids_date )

    # filter: color
    # fix me: tagged_with can not work with 'where' like Product.where(...).tagged_with(...)
    if params[:color].present?
      product_ids_color = Product.tagged_with(params[:color]).pluck(:id)
      product_ids = (product_ids & product_ids_color)
    end

    @products = Product.published.where("id IN (?) and count_on_hand > 0", product_ids)
    
    # filter: price
    @products = @products.where(price: Range.new(*params[:price_span].split(',').map(&:to_i))) if params[:price_span].present?

    # pagenator
    @products = @products.page(params[:page]).per(8).order_by_priority



    respond_to do |format|
      format.html {}
      format.js { render layout: false }
    end
  end

  def create_order
    # validate cookies[:cart]
    unless cookies[:cart]
      redirect_to products_quick_purchase_path, notice: "请添加产品"
      return
    end

    quick_purchase_form = session[:quick_purchase_form]
    quick_purchase_form.user = current_or_guest_user

    cart_cookies = JSON.parse(cookies[:cart]) 
    cart_cookies.each do |product_id, quantity|
      quick_purchase_form.add_line_item(product_id, quantity)
    end

    if quick_purchase_form.valid?
      quick_purchase_form.save
      empty_quick_purchase
      empty_cart
      redirect_to checkout_order_path(quick_purchase_form.record)
    else
      empty_quick_purchase
      redirect_to new_order_path, notice: "购物车存在不能送达产品，通过正常渠道结算"
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
  def session_quick_purchase_exist?
    unless session[:quick_purchase_form]
      redirect_to new_address_quick_purchase_path, notice: "请先填写地址"
      return
    end
  end

end
