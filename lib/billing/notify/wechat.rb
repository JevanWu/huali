require 'uri'

module Billing
  module Notify
    class Wechat < Notify::Base
      include Billing::Helper::Wechat

      def success?
        acknowledge? && super
      end

      private

      def parse(query)
        super
        @params['trade_no'] = @params['transaction_id']
        @params
      end

      def ipn_url
        "https://gw.tenpay.com/gateway/verifynotifyid.xml"
      end

      def ipn_query
        "notify_id=#{notify_id}&partner=#{ENV['WECHAT_PID']}"
      end

      def acknowledge?
        ipn_uri = URI("#{ipn_url}?#{add_sign(ipn_query)}")
        request = Net::HTTP::Get.new(ipn_uri)
        http = Net::HTTP.new(ipn_uri.host, ipn_uri.port)

        http.verify_mode    = OpenSSL::SSL::VERIFY_NONE unless @ssl_strict
        http.use_ssl        = true

        response = send_request(http, request)

        return false if response.nil?

        parsed_body = Hash.from_xml(response.body)["root"]

        @params['transaction_id'] == parsed_body["transaction_id"] && parsed_body["trade_state"] == "0"
      end

      def send_request(http, request)
        counter = 0
        begin
          return http.request(request)
        rescue
          counter += 1
          retry if counter < 2

          return nil
        end
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase
        query += "&sign=#{sign}"
      end
    end
  end
end
