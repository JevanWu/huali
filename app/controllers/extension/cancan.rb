module Extension
  module Cancan
    extend ActiveSupport::Concern

    included do
      # rescue cancan authorization failure
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, alert: exception.message
      end

      helper_method :current_ability, :current_admin_ability
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_admin_ability
      @current_admin_ability ||= AdminAbility.new(current_administrator)
    end
  end
end
