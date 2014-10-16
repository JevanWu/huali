module Billing
  module Return
    class Paypal < Return::Base
      include Billing::Helper::Paypal
      
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
