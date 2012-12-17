require 'digest/md5'
require 'open-uri'
class Transaction < ActiveRecord::Base
  Alipay_gateway = "https://www.alipay.com/cooperate/gateway.do?"
  Paypal_gateway = "https://www.paypal.com/cgi-bin/webscr?"
  class << self
    def alipay_gateway(query_hash={})
      Alipay_gateway + encode(translate_to_query_string(query_hash, "alipay"))
    end

    def paypal_gateway(query_hash={})
      Paypal_gateway + encode(translate_to_query_string(query_hash, "paypal"))
    end

    private
    def digest(query_string)
      Digest::MD5.hexdigest(query_string)
    end

    def translate_to_query_string(query_hash, gateway)
      case gateway
      when "alipay"
        key = query_hash[:key]
        query_hash = query_hash.delete_if {|key,value| key == :key }
        query_string = query_hash.sort.map do |key, value|
            "#{key}=#{value}"
            end.join("&")
        sign = digest(query_string + key)
        query_string += "&sign=#{sign}&sign_type=MD5"
      when "paypal"
        query_string = query_hash.map do |key, value|
          "#{key}=#{value}"
          end.join("&")
      end
    end

    def encode(query_string)
      URI::encode(query_string)
    end
  end
end
