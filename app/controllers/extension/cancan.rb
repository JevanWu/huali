module Extension
  module Cancan
    extend ActiveSupport::Concern

    included do
      # rescue cancan authorization failure
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to admin_dashboard_path, :alert => exception.message
      end
    end

    # cancan's ability
    def current_ability
      current_user = current_administrator ? current_administrator : current_user
      @current_ability ||= Ability.new(current_user)
    end
  end
end
