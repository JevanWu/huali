require 'digest/md5'
require 'uri'

module Billing
  module Helper
    module Paypal
      def success?
        right_amount? && payment_status == "Completed"
      end

      def right_amount?
        amt.to_f == to_dollar(@opts[:amount])
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
