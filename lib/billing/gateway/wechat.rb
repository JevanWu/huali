require 'digest/md5'

module Billing
  module Gateway
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
          fee_type: "1",
          bank_type: "WX",
          return_url: return_order_url(host: $host || 'localhost'),
          notify_url: notify_order_url(host: $host || 'localhost'),

          # shared options
          body: @opts[:subject],
          out_trade_no: @opts[:identifier],
          total_fee: (@opts[:amount] * 100).to_i,
          spbill_create_ip: @opts[:client_ip]
        }
      end

      def to_options(opts)
        {}
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase
        query += "&sign=#{sign}"
      end
    end
  end
end

