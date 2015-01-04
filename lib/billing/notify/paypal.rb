require 'uri'

module Billing
  module Notify
    class Paypal < Notify::Base
      include Billing::Helper::Paypal

      def success?
        acknowledge? && right_amount? 
      end

      def payment_status
        payment_status
      end

      private

      def parse(post)
        super
        @params['trade_no'] = @params['txn_id']
        @params['amt'] = @params['payment_gross']
        @params
      end

      def ipn_url
        Rails.env == 'development' ? "https://www.sandbox.paypal.com/cgi-bin/webscr?" : "https://www.paypal.com/cgi-bin/webscr?"
      end

      def ipn_validation_path
        URI.parse(ipn_url).path + "?cmd=_notify-validate"
      end

      def acknowledge?
        uri = URI.parse(ipn_url)
        request = Net::HTTP::Post.new(ipn_validation_path)
        request['Content-Length'] = "#{raw.size}"

        http = Net::HTTP.new(uri.host, uri.port)

        http.verify_mode    = OpenSSL::SSL::VERIFY_NONE unless @ssl_strict
        http.use_ssl        = true

        res = http.request(request, raw)

        res.body == "VERIFIED"
        # TODO verified failed
      end
    end
  end
end
