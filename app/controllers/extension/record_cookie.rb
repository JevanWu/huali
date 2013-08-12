module Extension
  module RecordCookie
    extend ActiveSupport::Concern

    def touch_or_create_tracking_cookie(user)
      tracking_cookie = TrackingCookie.find_or_create_by(user_id: user.id)
      tracking_cookie[:ga_client_id] = cookies['ga_client_id']
      tracking_cookie.save
    end
  end
end
