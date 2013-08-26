module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def sanitized(original_phone, phone_calling_code)
        if phone_calling_code == "+86"
          sanitized = Phonelib.parse(original_phone).sanitized.sub(/^86/, '')

          if !sanitized.start_with?('1') # Fixed line need to be prefixed with '0'
            sanitized = "0#{sanitized}"
          else
            sanitized
          end
        else
          phone_to_parse =  "#{phone_calling_code} #{original_phone}"
          "+#{Phonelib.parse(phone_to_parse).sanitized}"
        end
      end
    end

    module ClassMethods
      def phoneize(*attributes)
        attributes.each do |attribute|
          attr_accessor :"#{attribute}_calling_code"

          define_method(:"#{attribute}=") do |phone_with_calling_code|
            if phone_with_calling_code.is_a?(String)
              super(phone_with_calling_code) and return
            end

            phone_calling_code, original_phone = phone_with_calling_code
            send(:"#{attribute}_calling_code=", phone_calling_code)

            return unless original_phone.present?

            sanitized_phone = sanitized(original_phone, phone_calling_code)
            super(sanitized_phone)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
