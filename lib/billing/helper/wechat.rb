require 'digest/md5'
require 'uri'

module Billing
  module Helper
    module Wechat
      def success?
        verified? && right_amount? && trade_state.to_s == "0"
      end

      private

      def right_amount?
        total_fee.to_f == @opts[:amount] * 100 # The unit of total_fee is 分
      end

      def verified?
        verify_sign && verify_seller
      end

      def verify_seller
        partner == ENV['WECHAT_PID']
      end

      def verify_sign
        @sign_type ||= @params["sign_type"]
        @sign ||= @params["sign"]

        # custom_id and sign are excluded in MD5 calculation
        query = @params.except('sign', 'trade_no', 'custom_id').sort.map do |key, value|
          "#{key}=#{value}"
        end.join('&')

        Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase == @sign
      end
    end
  end
end
