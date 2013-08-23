module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      # This methods sets the attribute to the normalized version.
      def phonelib_normalize(*attributes)
        attributes.each do |attribute|
          phone = Phonelib.parse(self.send(attribute))
          normalized = (phone.country == Phonelib.default_country) ?
            phone.national : phone.international

          self.send("#{attribute}=", normalized)
        end
      end
    end

    module ClassMethods
      def phoneize(*attributes)
        attributes.each do |attribute|
          attr_accessor :"#{attribute}_calling_code"

          before_validation do
            original_phone = self.send(attribute)
            phone_calling_code = self.send(:"#{attribute}_calling_code")

            if original_phone.present? && !(phone_calling_code == CountryCode.default.calling_code)
              self.send("#{attribute}=", "#{phone_calling_code} #{original_phone}")
            end
          end
        end

        before_save do
          phonelib_normalize(*attributes)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
