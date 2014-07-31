module Billing
  module Link
    class Alipay
      def initialize(opts, query = nil)
        @opts = opts
      end

      def to_s
        "https://merchantprod.alipay.com/trade/refund/fastPayRefund.htm?tradeNo=#{@opts[:merchant_trade_no]}&action=detail"
      end
    end
  end
end
