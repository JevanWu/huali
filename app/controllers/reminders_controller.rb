class RemindersController < ApplicationController
  layout 'horizontal'
  before_filter :load_cart
  before_filter :fetch_items, only: [:new, :create, :current]

  include ::Extension::Order

  def new
    @reminder = Reminder.new
    @reminder.email = current_user.try(:email)

    product_id = params[:product_id]

    unless @cart.keys.include? product_id
      @products.push Product.find_by_id(product_id)
    end
  end

  def create
    product_ids = params[:reminder].delete(:product_ids)
    @reminder = Reminder.new(params[:reminder])


    if @reminder.save
      Notify.delay_until(@reminder.send_date - 2.day).reminder_user_email(@reminder.id, *product_ids)
      flash[:notice] = t(:reminder_success)
      redirect_to :root
    else
      render 'new'
    end
  end
end
