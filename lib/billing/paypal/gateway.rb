module Billing
  module Paypal
    class Gateway < Billing::Gateway
      SERVICE_URL = "https://www.paypal.com/cgi-bin/webscr?"

      DEFAULT_OPTS = {
        "cmd" => "_ext-enter",
        "redirect_cmd" => "_xclick",
        "charset" => "utf-8",
        "business" => Paypal::Email,
        "currenct_code" => "USD"
      }

      # {
      #   "item_name" => 'name,
      #   "amount" => number
      # }
      def initialize(options)
        @options = DEFAULT_OPTS.merge(options)
      end

      def purchase_path
        check_options!
        SERVICE_URL + URI::encode(query_string)
      end

      private

      def check_options!
        # TODO implement the error handling logic from Alipay Doc
        # check the presence of required params
        # check the type of certain params
        self
      end
    end
  end
end
