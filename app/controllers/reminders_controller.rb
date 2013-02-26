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

  end
end
