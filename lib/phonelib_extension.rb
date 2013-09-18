require 'phonelib'
require 'active_support/concern'

module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      def prefix(sign, number)
        sign.to_s + number.to_s
      end

      def sanitize_phone(original_phone, phone_calling_code)
        original_phone.sub!(/^0*/, '') if phone_calling_code == '+86'

        sanitized = Phonelib.parse("#{phone_calling_code}#{original_phone}").sanitized
        prefix('+', sanitized)
      end
    end

    module ClassMethods
      def phoneize(*attributes)
        attributes.each do |attribute|
          attr_accessor :"#{attribute}_calling_code"

          define_method(:"#{attribute}=") do |number|
            case number
            when String
              phone_calling_code, original_phone = number.slice!(/^\+\d+/), number
            when Array
              phone_calling_code, original_phone = number
            else
              raise ArgumentError
            end

            send(:"#{attribute}_calling_code=", phone_calling_code)

            return unless original_phone.present?

            super sanitize_phone(original_phone, phone_calling_code)
          end

          define_method(attribute) do
            original_phone = super() || ''
            parsed_phone = Phonelib.parse(original_phone)

            return original_phone unless parsed_phone.valid?

            parsed_phone.international
          end
        end
      end
    end
  end
end