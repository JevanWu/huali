module Billing
  module Return
    class Wechat < Base
      include Billing::Helper::Wechat

      private

      def parse(query_string)
        super
        @params['trade_no'] = @params['transaction_id']
        @params
      end
    end
  end
end
