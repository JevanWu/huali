module Wechat
  class WechatHelper

    def self.wechat_oauth_url(target, redirect_url, code = "")
      if target == :code
        return "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + ENV["WECHAT_APPID"] + "&redirect_uri="+ CGI.escape(redirect_url) + "&response_type=code&scope=" + "snsapi_base" + "&state=123#wechat_redirect"
      elsif target == :access_token
        return "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + ENV["WECHAT_APPID"] + "&secret=" + ENV["WECHAT_APPSECRET"] + "&code=" + code + "&grant_type=authorization_code"
      end
    end

    # Access Token Response:
    # {"access_token":"ACCESS_TOKEN","expires_in":7200}
    def self.get_access_token
      redis = Redis.new
      got_time = redis.get("access_token_got_time")
      return redis.get("access_token") if got_time.present? && (Time.now - got_time).to_i < redis.get("access_token_expires_in")

      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + ENV["WECHAT_APPID"] + "&secret=" + ENV["WECHAT_APPSECRET"]
      raw_res = RestClient.get url
      res = JSON.parse raw_res
      redis.set("access_token_got_time", Time.now)
      redis.set("access_token_expires_in", res["expires_in"])
      access_token = res["access_token"]
      redis.set("access_token", access_token)
      return access_token
    end

    def self.deliver_notify(order_id)
      order = Order.find order_id
      return unless order.transaction
      return if order.transaction.paymethod != "wechat_mobile"
      url = "https://api.weixin.qq.com/pay/delivernotify?access_token=" + self.get_access_token
      user_oauth = order.user.oauth_providers.where(provider: "wechat").take
      return unless user_oauth
      timestamp = Time.now.to_i.to_s
      parameters = {
        appid: ENV["WECHAT_APPID"],
        openid: user_oauth.identifier,
        transid: order.transaction.merchant_trade_no,
        out_trade_no: order.identifier,
        deliver_timestamp: timestamp,
        deliver_status: "1",
        deliver_msg: "ok",
        app_signature: sign(user_oauth.identifier, order.identifier, order.transaction.merchant_trade_no, timestamp),
        sign_method: "sha1"
      }

      res = JSON.parse(RestClient.post(url, parameters.to_json))
      if res["errcode"] != 0
        raise ArgumentError, res["errmsg"]
      end
    end

    private 
      def self.sign(openid, out_trade_no, transid, timestamp)
        app_id = ENV["WECHAT_APPID"]
        app_key = ENV["WECHAT_APPKEY"] 
        deliver_msg = "ok"
        deliver_status = "1"
        deliver_timestamp = timestamp
        openid = openid
        out_trade_no = out_trade_no
        transid = transid

        keyvaluestring = "appid="+app_id+"&appkey="+app_key+"&deliver_msg="+deliver_msg+"&deliver_status="+deliver_status+"&deliver_timestamp="+deliver_timestamp+"&openid="+openid+"&out_trade_no="+out_trade_no+"&transid="+transid
        sign = Digest::SHA1.hexdigest(keyvaluestring).to_s
        return sign
      end
  end
end
