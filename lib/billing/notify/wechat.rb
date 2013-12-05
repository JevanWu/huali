require 'uri'

module Billing
  class Notify
    class Wechat < Base
      include Billing::Helper::Wechat

      def success?
        acknowledge? && super
      end

      private

      def parse(post)
        @raw = post.to_s
        @params = Hash.from_xml(post)["root"]
        @params['trade_no'] = @params['transaction_id']
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

        res = http.request(request)

        Hash.from_xml(res.body)["root"]["trade_state"] == "0"
        # TODO verified failed
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase
        query += "&sign=#{sign}&sign_type=MD5"
      end
    end
  end
end
