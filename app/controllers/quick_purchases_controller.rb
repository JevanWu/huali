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
      redirect_to root_path, notice: "地址已更新"
    else
      redirect_to new_address_quick_purchase_path
    end
    #@quick_purchase_form.user = current_or_guest_user
    #@quick_purchase_form.kind = :quick_purchase
  end

  def new_products
  end

  private
  def get_quick_purchase_session
    @quick_purchase_form = if session[:quick_purchase_form] and !session[:quick_purchase_form].empty?
                               JSON.parse(cookies[:quick_purchase])
                             else
                               {}
                             end
  end
  def save_quick_purchase_cookies
    cookies[:quick_purchase] = JSON.generate(@quick_purchase_cookies) if @quick_purchase_cookies
  end
  def empty_quick_purchase_cookies
    cookies[:quick_purchase] = {}
  end

end
