module Extension
  module SignInRedirect
    extend ActiveSupport::Concern

    included do
      after_filter :store_location
    end

    def store_location
      # store last url as long as it isn't a /users path or /administrator path
      # avoid redirect loop
      session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users|\/administrators/
    end

    def after_sign_in_path_for(resource)
      case resource
      when User
        migrate_from_guest
        touch_or_create_tracking_cookie(resource)
        session[:previous_url] || root_path
      when Administrator
        admin_root_path
      end
    end
  end
end
