module Billing
  module Link
    class Paypal
      def initialize(opts, query = nil)
        @opts = opts
      end

      def to_s
        "https://www.paypal.com/c2/cgi-bin/webscr?cmd=_view-a-trans&id=#{@opts[:merchant_trade_no]}"
      end
    end
  end
end
