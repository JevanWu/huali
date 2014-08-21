module Wechat
  class WechatHelper

    def self.wechat_oauth_url(target, redirect_url, code = "")
      if target == :code
        return "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + ENV["WECHAT_APPID"] + "&redirect_uri="+ CGI.escape(redirect_url) + "&response_type=code&scope=" + "snsapi_base" + "&state=123#wechat_redirect"
      elsif target == :access_token
        return "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + ENV["WECHAT_APPID"] + "&secret=" + ENV["WECHAT_APPSECRET"] + "&code=" + code + "&grant_type=authorization_code"
      end
    end

    def self.get_access_token
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + ENV["WECHAT_APPID"] + "&secret=" + ENV["WECHAT_APPSECRET"]
      raw_res = RestClient.get url
      res = JSON.parse raw_res
      access_token = res["access_token"] || ""
    end

    def self.deliver_notify
      url = "https://api.weixin.qq.com/pay/delivernotify?access_token=" + self.get_access_token
      parameter = {
        "appid" : ENV["WECHAT_APPID"],
        "openid" : "oX99MDgNcgwnz3zFN3DNmo8uwa-w",
        "transid" : "111112222233333",
        "out_trade_no" : "555666uuu",
        "deliver_timestamp" : "1369745073",
        "deliver_status" : "1",
        "deliver_msg" : "ok",
        "app_signature" : "53cca9d47b883bd4a5c85a9300df3da0cb48565c", "sign_method" : "sha1"
      }
    end
  end
end
