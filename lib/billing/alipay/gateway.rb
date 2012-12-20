module Billing
  module Alipay
    class Gateway
      attr_reader :service_url
      service_url = "https://www.alipay.com/cooperate/gateway.do?"

      def initialize(transaction, type)

      end


      def purchase_path

      end

      private

      def sign(query)

      end
    end
  end
end
