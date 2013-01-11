module Extension
  module Locale
    extend ActiveSupport::Concern

    included do
      before_filter :set_locale
    end

    private

    # i18n helpers
    def set_locale
      I18n.locale = extract_locale_from_subdomain || I18n.default_locale
    end

    def extract_locale_from_subdomain
      parsed_locale = request.subdomains.first
      unless parsed_locale.nil?
        I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale : nil
      else
        nil
      end
    end
  end
end
