class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Utils.delay.subscribe_to_mailchimp(user.email, user.name)
  end
end
