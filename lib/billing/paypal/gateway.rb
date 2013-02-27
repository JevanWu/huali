module Billing
  module Paypal
    class Gateway < Billing::Gateway
      if ENV["RAILS_ENV"] == 'production'
        SERVICE_URL = "https://www.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_EMAIL']
        TOKEN = ENV['PAYPAL_TOKEN']
      else
        SERVICE_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_SANDBOX_EMAIL']
        TOKEN = ENV['PAYPAL_SANDBOX_TOKEN']
      end

      # Check the Documentation
      # https://www.x.com/developers/paypal/documentation-tools/paypal-payments-standard/integration-guide/Appx_websitestandard_htmlvariables

      DEFAULT_OPTS = {
        cmd: "_ext-enter",
        redirect_cmd: "_xclick",
        charset: "utf-8",
        business: PAYPAL_EMAIL,
        currency_code: "USD"
      }

      # {
      #   item_name: 'name,
      #   amount: number
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
