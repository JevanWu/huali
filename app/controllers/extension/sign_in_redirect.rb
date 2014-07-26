module Extension
  module SignInRedirect
    extend ActiveSupport::Concern

    def after_sign_in_path_for(resource)
      if User === resource
        migrate_from_guest
        track_user(resource)
      end

      session["user_return_to"] || root_path
    end

    def track_user(user)
      touch_or_create_tracking_cookie(user)

      Analytics.identify(user_id: user.id,
                         traits: { name: user.name,
                                   email: user.email,
                                   phone: user.phone,
                                   created_at: user.created_at },
                         context: {
                           'Google Analytics' => { clientId: user.tracking_cookie.ga_client_id }
                         })

      if user.created_at > 10.seconds.ago # new user
        Analytics.track(user_id: user.id,
                        event: 'Signed Up',
                        properties: {
                          label: user.email,
                          category: 'User'
                        },
                        context: {
                          'Google Analytics' => { clientId: user.tracking_cookie.ga_client_id }
                        })
      else
        Analytics.track(user_id: user.id,
                        event: 'Signed In',
                        properties: { category: 'User', label: user.email },
                        context: {
                          'Google Analytics' => { clientId: user.tracking_cookie.ga_client_id }
                        })
      end
    end
  end
end
