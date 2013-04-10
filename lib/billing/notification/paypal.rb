require 'uri'
require 'ostruct'

module Billing
  class Notification
    class Paypal < OpenStruct
      include Helper

      attr_accessor :params
      attr_accessor :raw

      def initialize(query_string)
        reset!
        # delegates OpenStruct.new to build all arbitrary attributes
        # cover ALL Paypal notify params
        result = parse(query_string)
        result["trade_no"] = result["txn_id"]
        # alias

        if !acknowledge?
          return false
        end

        super result
      end

      def acknowledge?
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
    end
  end
end
