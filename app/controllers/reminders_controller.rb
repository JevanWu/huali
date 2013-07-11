class RemindersController < ApplicationController
  layout 'horizontal'
  before_action :load_cart
  before_action :fetch_items, only: [:new, :create, :current]

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
    product_ids = reminder_params[:product_ids]
    @reminder = Reminder.new(reminder_params.except(:product_ids))


    if @reminder.save
      Notify.delay_until(@reminder.send_date - 2.day).reminder_user_email(@reminder.id, *product_ids)
      flash[:notice] = t('controllers.reminder.reminder_success')
      redirect_to :root
    else
      render 'new'
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:email, :send_date, :note, :product_ids)
  end
end
