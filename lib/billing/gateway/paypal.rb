module Billing
  class Gateway
    class Paypal < Base

      if Rails.env == 'development'
        SERVICE_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_SANDBOX_EMAIL']
        TOKEN = ENV['PAYPAL_SANDBOX_TOKEN']
      else
        SERVICE_URL = "https://www.paypal.com/cgi-bin/webscr?"
        PAYPAL_EMAIL = ENV['PAYPAL_EMAIL']
        TOKEN = ENV['PAYPAL_TOKEN']
      end

      def purchase_path
        SERVICE_URL + URI::encode(query_string)
      end

      private

      # Check the Documentation
      # https://www.x.com/developers/paypal/documentation-tools/paypal-payments-standard/integration-guide/Appx_websitestandard_htmlvariables

      def default_opts
        {
          cmd: "_ext-enter",
          redirect_cmd: "_xclick",
          charset: "utf-8",
          business: PAYPAL_EMAIL,
          currency_code: "USD",
          return_url: return_order_url(host: $host || 'localhost') + custom_data,
          notify_url: notify_order_url(host: $host || 'localhost') + custom_data
        }
      end

      def to_options(opts)
        {
          item_name: opts[:subject],
          invoice: opts[:identifier],
          amount: to_dollar(opts[:amount])
        }
      end

      def to_dollar(amount)
        dollar = amount / 6.0
        # round the dollar amount to 10x
        round = (dollar / 10.0).ceil * 10

        # adjust the number to 5x
        # 124.234 -> 124.99 ; 126.23 -> 129.99
        adjust = (dollar % 10 > 5) ? 0.01 : (5 + 0.01)

        round - adjust
      end
    end
  end
end
