require 'digest/md5'

module Billing
  class Gateway
    class Wechat < Gateway::Base

      SERVICE_URL = "https://gw.tenpay.com/gateway/pay.htm?"

      def initialize(opts, query = nil)
        super
      end

      def to_s
        query = add_sign(query_string)
        SERVICE_URL + URI.encode(query)
      end

      private

      def default_opts
        {
          # gateway related
          partner: ENV['WECHAT_PID'],
          input_charset: "UTF-8",

          # default options
          fee_type: "1"
          return_url: return_order_url(host: $host || 'localhost') + custom_data,
          notify_url: notify_order_url(host: $host || 'localhost') + custom_data,

          # shared options
          body: @opts[:body],
          out_trade_no: @opts[:identifier],
          total_fee: @opts[:amount],
          spbill_create_ip: @opts[:client_ip]
        }
      end

      def to_options(opts)
        {}
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase
        query += "&sign=#{sign}&sign_type=MD5"
      end
    end
  end
end

