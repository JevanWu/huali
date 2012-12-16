require 'digest/md5'
require 'open-uri'
class Transaction < ActiveRecord::Base
  class << self
    def alipay_gateway(query_hash={})
      "https://www.alipay.com/cooperate/gateway.do?" + digest_and_encode(query_hash, "alipay")
    end

    def paypal_gateway(query_hash={})
      "https://www.paypal.com/cgi-bin/webscr?" +digest_and_encode(query_hash, "paypal")
    end

    private
    def digest_and_encode(query_hash,gateway)
      case gateway
      when "alipay"
        key = query_hash[:key]
        query_hash = query_hash.delete_if {|key,value| key == :key }
        query_string = query_hash.sort.map do |key, value|
            "#{key}=#{value}"
            end.join("&")
        sign = Digest::MD5.hexdigest(query_string + key)
        query_string += "&sign=#{sign}&sign_type=MD5"
        query_string = URI::encode(query_string)
      when "paypal"
        URI::encode("cmd=_ext-enter&redirect_cmd=_xclick&charset=utf-8&business=#{query_hash[:paypal_email]}&currenct_code=USD&item_name=#{query_hash[:item_name]}&amount=#{query_hash[:amount]}" )
      end
    end
  end
end
