require 'digest/md5'
require 'uri'

module Billing
  module Alipay
    module Sign
      def verify_sign(params)
        sign_type = params.delete("sign_type")
        sign = params.delete("sign")

        query_string = params.sort.map do |key, value|
          "#{key}=#{URI.decode(value)}"
        end.join('&')

        Digest::MD5.hexdigest(query + Alipay::Key) == sign.downcase
      end
    end
  end
end
