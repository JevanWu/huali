class RemindersController < ApplicationController
  layout 'horizontal'
  before_filter :load_cart
  before_filter :fetch_items, only: [:new, :create, :current]

  include ::Extension::Order

  def new
    @reminder = Reminder.new
    @reminder.email = current_user.try(:email)
  end

  def create
    @reminder = Reminder.new(params[:reminder])

    if @reminder.save
      Notify.delay_until(@reminder.send_date).new_order_user_email(376)
      flash[:notice] = t(:reminder_success)
      redirect_to :back
    else
      render 'new'
    end


  end
end
