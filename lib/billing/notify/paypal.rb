require 'uri'
require 'ostruct'

module Billing
  class Notify
    class Paypal < OpenStruct
      include Billing::Helper::Paypal

      attr_accessor :params, :raw

      def initialize(opts, post)
        @opts = opts
        reset!

        result = parse(post)
        result['trade_no'] = result['txn_id']
        result['amt'] = result['payment_gross']

        super result
      end

      def success?
        acknowledge? && right_amount? && payment_status == "Completed"
      end

      private

      # reset the notification.
      def reset!
        @params  = {}
        @raw     = ""
      end

      # Take the posted data and move the relevant data into a hash
      def parse(query_string)
        @raw = query_string.to_s
        for line in @raw.split('&')
          key, value = *line.scan( %r{^([A-Za-z0-9_.]+)\=(.*)$} ).flatten
          params[key] = URI.decode(value)
        end
        params
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
