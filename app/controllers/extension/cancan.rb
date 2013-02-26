module Extension
  module Cancan
    extend ActiveSupport::Concern

    included do
      # rescue cancan authorization failure
      rescue_from CanCan::AccessDenied do |exception|
        redirect_to :back, alert: exception.message
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
  end
end
