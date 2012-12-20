module Billing
  module Alipay
    class Gateway < Billing::Gateway
      SERVICE_URL = "https://www.alipay.com/cooperate/gateway.do?"

      DEFAULT_OPTS = {
        # gateway related
        "seller_email" => Alipay::Email,
        "partner" => Alipay::Pid,
        "_input_charset" => "utf-8",
        "service" => "create_direct_pay_by_user",

        # default options
        "payment_type" => "1",
        "paymethod" => "directPay"
      }

      # options = {
      # "out_trade_no" => 'ANS12345678',
      # "subject" => name,
      # "total_fee" => '12',
      # "body" => content,
      # "show_url" => '',
      # "return_url" => "http://hua.dev/success/#{product.id}",
      # "notify_url" => "http =>//hua.dev/notify",
      # "error_notify_url" => "http =>//hua.dev/notify_error",
      # "paymethod" => "bankPay",
      # "defaultbank" => 'CMB
      # }
      def initialize(options)
        @options = DEFAULT_OPTS.merge(options)
      end

      def purchase_path
        check_options!
        query = add_sign(query_string)
        SERVICE_URL + URI::encode(query)
      end

      private

      def check_options!
        # TODO implement the error handling logic from Alipay Doc
        # check the presence of required params
        # check the type of certain params
        self
      end

      def add_sign(query)
        sign = Digest::MD5.hexdigest(query + Alipay::Key)
        query += "&sign=#{sign}&sign_type=MD5"
      end
    end
  end
end
