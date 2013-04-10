require 'digest/md5'
require 'billing/gateway/base'

module Billing
  class Gateway
    class Alipay < Base

      SERVICE_URL = "https://www.alipay.com/cooperate/gateway.do?"

      def initialize(opts)
        validate_merchant_name(opts) if opts[:paymethod] == 'bankPay'
        super
      end

      def purchase_path
        query = add_sign(query_string)
        SERVICE_URL + URI.encode(query)
      end

      private

      # options = {
      # out_trade_no: 'ANS12345678',
      # subject: name,
      # total_fee: '12',
      # body: 'content',
      # show_url: '',
      # return_url: "http://hua.dev/success/file",
      # notify_url: "http =>//hua.dev/notify",
      # error_notify_url: "http =>//hua.dev/notify_error",
      # paymethod: "bankPay",
      # defaultbank: 'CMB'
      # }

      def default_opts
        {
          # gateway related
          seller_email: ENV['ALIPAY_EMAIL'],
          partner: ENV['ALIPAY_PID'],
          _input_charset: "utf-8",
          service: "create_direct_pay_by_user",

          # default options
          payment_type: "1",
          paymethod: "directPay",
          return_url: return_order_url(host: $host || 'localhost') + custom_data,
          notify_url: notify_order_url(host: $host || 'localhost') + custom_data,

          # shared options
          subject: @opts[:subject],
          body: @opts[:body],
          out_trade_no: @opts[:identifier],
          total_fee: @opts[:amount],
        }
      end

      def to_options(opts)
        if opts[:paymethod] == "directPay"
          # directPay requires the defaultbank to be blank
          { pay_bank: 'directPay', defaultbank: '' }
        else
          { pay_bank: 'bankPay', defaultbank: opts[:merchant_name] }
        end
      end

      def validate_merchant_name(opts)
        raise ArgumentError, 'merchant_name is required for bankPay' if opts[:merchant_name].nil?
      end


      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + ENV['ALIPAY_KEY'])
        query += "&sign=#{sign}&sign_type=MD5"
      end
    end
  end
end
