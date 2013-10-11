class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Utils.delay.subscribe_to_mailchimp(user.email, user.name)
    AnalyticWorker.delay.identify_user(user.id)
    GaTrackWorker.delay.user_sign_up_track(user.id)
  end
end
