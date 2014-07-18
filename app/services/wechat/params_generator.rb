require 'uri'
require 'cgi'
require 'digest'

module Wechat
  class ParamsGenerator
    def self.get_appid
      ENV["WECHAT_APPID"]
    end

    def self.get_package(order, client_ip)
      banktype = "WX"
      body = order.products.first.name_zh 
      fee_type = "1"
      input_charset = "GBK"
      notify_url = "http://staging_wechat.zenhacks.org/orders/gateway"
      out_trade_no = order.identifier
      partner = ENV["WECHAT_PARTNERID"]
      spbill_create_ip = client_ip 
      total_fee = order.total.to_s
      partnerKey = ENV["WECHAT_PARTNERKEY"] 
    
      signString = "bank_type="+banktype+"&body="+body+"&fee_type="+fee_type+"&input_charset="+input_charset+"&notify_url="+notify_url+"&out_trade_no="+out_trade_no+"&partner="+partner+"&spbill_create_ip="+spbill_create_ip+"&total_fee="+total_fee+"&key="+partnerKey
    
      md5SignValue = ("" + Digest::MD5.hexdigest(signString)).upcase
    
      banktype = URI.escape(banktype)
      body = URI.escape(body)
      fee_type = URI.escape(fee_type)
      input_charset = URI.escape(input_charset)
      notify_url = CGI.escape(notify_url)
      out_trade_no = URI.escape(out_trade_no)
      partner = URI.escape(partner)
      spbill_create_ip = URI.escape(spbill_create_ip)
      total_fee = URI.escape(total_fee)
    
      completeString = "bank_type="+banktype+"&body="+body+"&fee_type="+fee_type+"&input_charset="+input_charset+"&notify_url="+notify_url+"&out_trade_no="+out_trade_no+"&partner="+partner+"&spbill_create_ip="+spbill_create_ip+"&total_fee="+total_fee
      completeString = completeString + "&sign=" + md5SignValue
   
      return completeString
    end

    def self.get_timestamp
      timestampstring = Time.now.to_s
    end

    def self.get_nonce_str
      chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      maxPos = chars.length
      noceStr = ""
      for i in (0...32) 
          noceStr += chars[Random.new.rand(0...maxPos)]
      end
      return noceStr
    end

    def self.get_signtype
      return "SHA1"
    end

    def self.get_sign(nonce_str, package_str, timestamp)
      app_id = ENV["WECHAT_APPID"]
      app_key = ENV["WECHAT_APPKEY"] 
      nonce_str = nonce_str 
      package_string = package_str
      time_stamp = timestamp
      keyvaluestring = "appid="+app_id+"&appkey="+app_key+"&noncestr="+nonce_str+"&package="+package_string+"&timestamp="+time_stamp
      sign = Digest::SHA1.hexdigest(keyvaluestring).to_s
      return sign
    end
  end
end
