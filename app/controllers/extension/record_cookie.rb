module Extension
  module RecordCookie
    extend ActiveSupport::Concern

    def touch_or_create_tracking_cookie(user)
      if user.tracking_cookie
        user.tracking_cookie.update_column(:ga_client_id, fetch_ga_client_id)
      else
        user.create_tracking_cookie(ga_client_id: fetch_ga_client_id)
      end
    end

    def fetch_ga_client_id
      return if cookies[:_ga].nil?

      cookies[:_ga] =~ /GA\d\.\d\.(.*)/
      $1
    end
  end
end
