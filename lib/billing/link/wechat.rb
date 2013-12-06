module Billing
  class Link
    class Wechat
      def initialize(opts, query = nil)
        @opts = opts
      end

      def to_s
        "https://hua.li/?not_implemented=#{@opts[:merchant_trade_no]}"
      end
    end
  end
end
