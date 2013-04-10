require 'digest/md5'
require 'uri'

module Billing
  class Gateway
    class Alipay
      include Rails.application.routes.url_helpers

      SERVICE_URL = "https://www.alipay.com/cooperate/gateway.do?"


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
      def initialize(opts)
        @opts = opts
        validate_merchant_name if @opts[:paymethod] == 'bankPay'

        @options = default_opts.merge to_options(opts)

      end

      def validate_merchant_name
        raise ArgumentError, 'merchant_name is required for bankPay' if @opts[:merchant_name].nil?
      end

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

      def purchase_path
        check_options!
        query = add_sign(query_string)
        SERVICE_URL + URI.encode(query)
      end

      private

      def to_options(opts)
        if opts[:paymethod] == "directPay"
          # directPay requires the defaultbank to be blank
          { pay_bank: 'directPay', defaultbank: '' }
        else
          { pay_bank: 'bankPay', defaultbank: opts[:merchant_name] }
        end
      end

      def check_options!
        # TODO implement the error handling logic from Alipay Doc
        # check the presence of required params
        # check the type of certain params
        self
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + ENV['ALIPAY_KEY'])
        query += "&sign=#{sign}&sign_type=MD5"
      end

      # FIXME this should be shared between all gateways
      # maybe use a module
      def query_string
        compacted_options.map do |k, v|
          "#{k}=#{v}"
        end.sort * '&'
      end

      def compacted_options
        @options.select do |key, value|
          not value.blank?
        end
      end

      def custom_data
        '?' + URI.encode_www_form(custom_id: @opts[:identifier])
      end
    end
  end
end
