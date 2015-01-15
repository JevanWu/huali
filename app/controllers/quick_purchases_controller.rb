class QuickPurchasesController < ApplicationController
  before_action :get_quick_purchase_cookies, only: [ :edit_sender, :save_sender, :edit_receiver, :save_receiver ]

  def edit_sender
  end
  def save_sender
    @quick_purchase_cookies.merge!( {"sender" => params[:sender_info]} )
    redirect_to edit_receiver_quick_purchase_path if save_quick_purchase_cookies
  end

  def edit_receiver
  end
  def save_receiver
    @quick_purchase_cookies.merge!( {"receiver" => params[:receiver_info]} )
    redirect_to root_path if save_quick_purchase_cookies
  end


  def order_new
    @quick_purchase_form = QuickPurchaseForm.new
    @quick_purchase_form.sender = SenderInfo.new
    @quick_purchase_form.address = ReceiverInfo.new
  end
  def order_create
    @quick_purchase_form = QuickPurchaseForm.new(params[:quick_purchase_form])
    @quick_purchase_form.user = current_or_guest_user
    @quick_purchase_form.kind = :quick_purchase

    redirect_to '', flash: { success: "订单创建成功，请选花" } if @quick_purchase_form.save
      ## create line items
      #@cart.items.each do |item|
        #@secoo_order_form.add_line_item(item.product_id, item.quantity)
      #end

      #success = @secoo_order_form.save do |record|
        #yield(record) if block_given?
      #end
  end


  private
  def get_quick_purchase_cookies
    @quick_purchase_cookies = if cookies[:quick_purchase] and !cookies[:quick_purchase].empty?
                               JSON.parse(cookies[:quick_purchase])
                             else
                               {}
                             end
    @sender = @quick_purchase_cookies["sender"]
    @receiver = @quick_purchase_cookies["receiver"]
  end
  def save_quick_purchase_cookies
    cookies[:quick_purchase] = JSON.generate(@quick_purchase_cookies) if @quick_purchase_cookies
  end
  def empty_quick_purchase_cookies
    cookies[:quick_purchase] = {}
  end

end
