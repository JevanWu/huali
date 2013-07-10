module Billing
  class Return
    class Paypal < Base
      include Billing::Helper::Paypal
      
      def success?
        right_amount? && payment_status == "Completed"
      end

      def right_amount?
        amt.to_f == to_dollar(@opts[:amount])
      end

      private

      def parse(query_string)
        super
        @params['trade_no'] = @params['tx']
        @params['payment_status'] = @params['st']
        @params
      end
    end
  end
end
