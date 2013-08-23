module Phonelib
  module Extension
    extend ActiveSupport::Concern

    module ClassMethods
      def phoneize(*attributes)
        attributes.each do |attribute|
          attr_accessor :"#{attribute}_calling_code"

          before_validation do
            original_phone = self.send(attribute)

            if original_phone.present?
              phone = original_phone.sub(/^0*/, '')
              phone_calling_code = self.send(:"#{attribute}_calling_code")

              self.send("#{attribute}=", "#{phone_calling_code} #{phone}")
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
