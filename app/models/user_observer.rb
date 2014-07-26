class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Utils.delay.subscribe_to_mailchimp(user.email, user.name)
    Analytics.identify(user_id: user.id,
                       traits: { name: user.name,
                                 email: user.email,
                                 phone: user.phone,
                                 created_at: user.created_at })

    Analytics.track(user_id: user.id,
                    event: 'Signed Up',
                    properties: {
                      label: user.email,
                      category: 'User'
                    })
  end
end
