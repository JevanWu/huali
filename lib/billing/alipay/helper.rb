# encoding: utf-8
require 'digest/md5'
require 'uri'

module Billing
  module Alipay
    module Helper

      def verified?
        verify_sign && verify_seller
      end

      def complete?
        trade_status == "TRADE_FINISHED"
      end

      private

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
      end
    end
  end
end
