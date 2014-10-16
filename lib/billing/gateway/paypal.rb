module Billing
  module Gateway
    class Paypal < Gateway::Base
      include Billing::Helper::Paypal

      if Rails.env == 'development'
        SERVICE_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_SANDBOX_EMAIL']
        TOKEN = ENV['PAYPAL_SANDBOX_TOKEN']
      else
        SERVICE_URL = "https://www.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_EMAIL']
        TOKEN = ENV['PAYPAL_TOKEN']
      end

      def to_s
        SERVICE_URL + URI::encode(query_string)
      end

      private

      # Check the Documentation
      # https://developer.paypal.com/docs/classic/paypal-payments-standard/integration-guide/Appx_websitestandard_htmlvariables/

      def default_opts
        {
          cmd: "_ext-enter",
          redirect_cmd: "_xclick",
          charset: "utf-8",
          business: PAYPAL_EMAIL,
          currency_code: "USD",
          return: return_order_paypal_url(host: $host || 'localhost'),
          notify_url: notify_order_url(host: $host || 'localhost'),
          custom: @opts[:identifier]
        }
      end

      def to_options(opts)
        {
          item_name: opts[:subject],
          invoice: opts[:identifier],
          amount: to_dollar(opts[:amount])
        }
      end
    end
  end
end
