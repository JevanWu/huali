module Phonelib
  module Extension
    extend ActiveSupport::Concern

    included do
      private

      # This methods sets the attribute to the normalized version.
      def set_phonelib_normalized_numbers(*attributes)
        attributes.each do |attribute|
          phone = Phonelib.parse(self.send(attribute))
          normalized = (phone.country == Phonelib.default_country) ?
            phone.national : phone.international

          self.send("#{attribute}=", normalized)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Phonelib::Extension
