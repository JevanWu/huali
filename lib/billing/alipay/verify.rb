require 'digest/md5'
require 'uri'

module Billing
  module Alipay
    module Verify
      def verify_seller
        seller_email == Alipay::Email
      end

      def verify_sign
        sign_type = @params.delete("sign_type")
        sign = @params.delete("sign")

        query_string = @params.map do |key, value|
          "#{key}=#{URI.decode(value)}"
        end.sort * '&'

        Digest::MD5.hexdigest(query + Alipay::Key) == sign.downcase
      end
    end
  end
end
