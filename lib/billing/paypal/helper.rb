require 'digest/md5'
require 'uri'

module Billing
  module Paypal
    module Helper
      def ipn_url 
        Rails.env == 'production' ? "https://www.paypal.com/cgi-bin/webscr?" : "https://www.sandbox.paypal.com/cgi-bin/webscr?"
      end
      def ipn_validation_path
        URI.parse(ipn_url).path + "?cmd=_notify-validate"
      end
      def seller_mail
        Rails.env == 'production' ? ENV['PAYPAL_EMAIL'] : ENV['PAYPAL_SANDBOX_EMAIL']
      end

      def acknowledge
        uri = URI.parse(ipn_url)
        request = Net::HTTP::Post.new(ipn_validation_path)
        request['Content-Length'] = "#{raw.size}"

        http = Net::HTTP.new(uri.host, uri.port)

        http.verify_mode    = OpenSSL::SSL::VERIFY_NONE unless @ssl_strict
        http.use_ssl        = true

        request = http.request(request, raw)

        request.body == "VERIFIED"
        # TODO verified failed
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

      def to_dollar(amount)
        amount = amount.to_i
        dollar = amount / 6.0
        # round the dollar amount to 10x
        round = (dollar / 10.0).ceil * 10

        # adjust the number to 5x
        # 124.234 -> 124.99 ; 126.23 -> 129.99
        adjust = (dollar % 10 > 5) ? 0.01 : (5 + 0.01)

        round - adjust
      end


    end
  end
end
