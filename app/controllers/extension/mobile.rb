module Extension
  module Mobile
    extend ActiveSupport::Concern

    included do
      before_action :check_for_mobile
      helper_method :mobile_device?
    end

    private

    # mobile devise helper
    def check_for_mobile
      prepare_for_mobile if mobile_device?
    end

    def prepare_for_mobile
      prepend_view_path Rails.root + 'app' + 'views_mobile'
    end

    def mobile_device?
      params.has_key?(:mobile) ?  true :
        (request.user_agent =~ /Mobile|webOS/) &&
        # treat iPad as non-mobile.
        (request.user_agent !~ /iPad/)
    end
  end
end
