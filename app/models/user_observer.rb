class UserObserver < ActiveRecord::Observer
  def after_create(user)
    User.delay.subscribe_to_mailchimp(user.id)
    AnalyticWorker.delay.identify_user(user.id)
  end
end
