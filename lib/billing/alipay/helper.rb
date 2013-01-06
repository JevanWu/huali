require 'digest/md5'
require 'uri'

module Billing
  module Alipay
    module Helper

      alias :order :out_trade_no
      alias :amount :total_fee

      def success?
        verify_sign && verify_seller
      end

      def complete?
        trade_status == "TRADE_FINISHED"
      end

      def pending?
        trade_status == 'WAIT_BUYER_PAY'
      end

      private

      def verify_seller
        seller_email == ENV['ALIPAY_EMAIL']
      end

      def verify_sign
        sign_type = @params.delete("sign_type")
        sign = @params.delete("sign")

        query_string = @params.map do |key, value|
          "#{key}=#{URI.decode(value)}"
        end.sort * '&'

        Digest::MD5.hexdigest(query + ENV['ALIPAY_KEY']) == sign.downcase
      end
    end
  end
end
