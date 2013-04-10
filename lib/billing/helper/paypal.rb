require 'digest/md5'
require 'uri'

module Billing
  module Helper
    module Paypal
      def ipn_url
        Rails.env == 'production' ? "https://www.paypal.com/cgi-bin/webscr?" : "https://www.sandbox.paypal.com/cgi-bin/webscr?"
      end
      def ipn_validation_path
        URI.parse(ipn_url).path + "?cmd=_notify-validate"
      end
      def seller_mail
        Rails.env == 'production' ? ENV['PAYPAL_EMAIL'] : ENV['PAYPAL_SANDBOX_EMAIL']
      end

      def verified?
        verify_seller?
      end

      def success?
        payment_status == "Completed"
      end

      def verify_seller?
        return true
        # FIXME verify
        business == seller_mail
      end

    end
  end
end
