class UserObserver < ActiveRecord::Observer
  def after_create(user)
    user.delay.subscribe_to_mailchimp
  end
end
