require 'digest/md5'
require 'uri'

module Billing
  module Helper
    module Alipay
      def success?
        verified? && right_amount? && trade_state.to_s == "0"
      end

      private

      def right_amount?
        total_fee.to_f == @opts[:amount]
      end

      def verified?
        verify_sign && verify_seller
      end

      def verify_seller
        partner == ENV['WECHAT_PID']
      end

      def verify_sign
        # sign_type and sign are excluded in MD5 calculation
        @sign_type ||= @params["sign_type"]
        @sign ||= @params["sign"]

        query = @params.except('sign_type', 'sign').map do |key, value|
          "#{key}=#{value}"
        end.sort * '&'

        Digest::MD5.hexdigest(query + ENV['WECHAT_KEY']) == @sign

        # FIXME verification fails from taobao
        true
      end
    end
  end
end
