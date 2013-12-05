module Billing
  class Return
    class Wechat < Base
      include Billing::Helper::Wechat

      private

      def parse(post)
        @raw = post.to_s
        @params = Hash.from_xml(post)["root"]
        @params['trade_no'] = @params['transaction_id']
      end
    end
  end
end
