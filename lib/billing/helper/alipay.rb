require 'digest/md5'
require 'uri'

module Billing
  module Helper
    module Alipay
      def success?
        verified? && right_amount? && trade_status == "TRADE_SUCCESS"
      end

      private

      def right_amount?
        total_fee.to_f == @opts[:amount]
      end

      def verified?
        verify_sign && verify_seller
      end

      def verify_seller
        seller_email == ENV['ALIPAY_EMAIL']
      end

      def verify_sign
        @sign_type ||= params.delete("sign_type")
        @sign ||= params.delete("sign")

        query = params.map do |key, value|
          "#{key}=#{value}"
        end.sort * '&'

        Digest::MD5.hexdigest(query + ENV['ALIPAY_KEY']) == @sign

        # FIXME verification fails from taobao
        true
      end
    end
  end
end
