module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def phonelib_sanitize_with_calling_code(original_phone, phone_calling_code)
        if phone_calling_code == "+86"
          sanitized = Phonelib.parse(original_phone).sanitized.sub(/^86/, '')

          prefix_local_fixed_number(sanitized)
        else
          phone_to_parse = "#{phone_calling_code} #{original_phone}"
          prefix(:+, Phonelib.parse(phone_to_parse).sanitized)
        end
      end

      def phonelib_sanitize(original_phone)
        sanitized = Phonelib.parse(original_phone).sanitized

        if sanitized.start_with?('86')
          sanitized.sub!(/^86/, '')

          prefix_local_fixed_number(sanitized)
        else
          prefix(:+, sanitized)
        end
      end

      def prefix_local_fixed_number(phone)
        # Chinese fixed-line number needs to be prefixed with '0'
        # 400-* and cellphone numbers will be escaped
        phone.match(/^(400|1[^0])/) ? phone : prefix('0', phone)
      end

      def prefix(sign, number)
        sign.to_s + number.to_s
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

          define_method(attribute) do
            original_phone = super()
            parsed_phone = Phonelib.parse(String(original_phone))

            return original_phone unless parsed_phone.valid?

            if original_phone.start_with?('+')
              parsed_phone.international
            else
              parsed_phone.national
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
