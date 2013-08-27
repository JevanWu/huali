module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def phonelib_sanitize_with_calling_code(original_phone, phone_calling_code)
        if phone_calling_code == "+86"
          sanitized = Phonelib.parse(original_phone).sanitized.sub(/^86/, '')

          phonelib_fixed_line(sanitized)
        else
          phone_to_parse = "#{phone_calling_code} #{original_phone}"
          "+#{Phonelib.parse(phone_to_parse).sanitized}"
        end
      end

      def phonelib_sanitize(original_phone)
        sanitized = Phonelib.parse(original_phone).sanitized

        if sanitized.start_with?('86')
          sanitized.sub!(/^86/, '')

          phonelib_fixed_line(sanitized)
        else
          "+#{sanitized}"
        end
      end

      def phonelib_fixed_line(phone)
        # Chinese fixed-line number needs to be prefixed with '0'
        if phone.start_with?('400') || (phone.start_with?('1') && !phone.start_with?('10'))
          phone
        else
          "0#{phone}"
        end
      end
    end

    module ClassMethods
      def phoneize(*attributes)
        attributes.each do |attribute|
          attr_accessor :"#{attribute}_calling_code"

          define_method(:"#{attribute}=") do |phone_with_calling_code|
            case phone_with_calling_code
            when String
              super phonelib_sanitize(phone_with_calling_code)
            when Array
              phone_calling_code, original_phone = phone_with_calling_code
              send(:"#{attribute}_calling_code=", phone_calling_code)

              return unless original_phone.present?

              sanitized_phone = phonelib_sanitize_with_calling_code(original_phone,
                                                                    phone_calling_code)
              super(sanitized_phone)
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
