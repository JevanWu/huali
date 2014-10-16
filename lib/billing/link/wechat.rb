module Billing
  module Link
    class Wechat
      def initialize(opts, query = nil)
        @opts = opts
      end

      def to_s
        "https://mch.tenpay.com/cgi-bin/mch_tradedetail.cgi?tno=1&transaction_id=#{@opts[:merchant_trade_no]}"
      end
    end
  end
end
