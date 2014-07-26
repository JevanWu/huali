module Extension
  module RecordCookie
    extend ActiveSupport::Concern

    def touch_or_create_tracking_cookie(user)
      tracking_cookie = TrackingCookie.find_or_create_by(user_id: user.id)
      tracking_cookie[:ga_client_id] = fetch_ga_client_id
      tracking_cookie.save
    end

    def fetch_ga_client_id
      return if cookies[:_ga].nil?

      cookies[:_ga] =~ /GA\d\.\d\.(.*)/
      $1
    end
  end
end
