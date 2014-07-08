$(document).ready ->
  $("#getBrandWCPayRequest").click ->
    WeixinJSBridge.invoke('getBrandWCPayRequest', {
      "appId": getAppId
      "timeStamp": getTimeStamp
      "nonceStr": getNonceStr
      "package": getPackage
      "signType": getSignType
      "paySign": getPaySign
      }, (res) ->
        WeixinJSBridge.log(res.err_msg)
    )

  getAppId = ->
    return "wx2264bf970f03a387"

  getAppKey = ->
    return "46210ac8bcb0485ec97ceafa31b143c6"

  getPartnerId = ->
    return "1900000109"
    # return "1219894701"

  getPartnerKey = ->
    return "8934e7d15453e97507ef794cf7b0519d"
    # return "8934e7d15453e97507ef794cf7b0519d"

  getTimeStamp = ->
    timestamp = new Date().getTime()
    timestampstring = timestamp.toString()
    lastTimeStamp = timestampstring
    return timestampstring

  getNonceStr = ->
    nonceStr = ""
    rang = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    for i in [0..10]
      nonceStr += range.charAt(Math.floor(Math.random() * range.length))
    lastNonceStr = nonceStr
    return nonceStr

  getSignType ->
    return "SHA1"

  getPaySign ->
    app_id = getAppId().toString()
    app_key = getAppKey().toString()
    nonce_str = lastNonceStr
    package_str = lastPackageString
    time_stamp = lastTimeStamp
    keyValueString = "appid=" + app_id + "&appkey=" + app_key + "&noncestr=" + nonce_str + "&package=" + package_str + "&timestamp=" + time_stamp
    sign = CryptoJS.SHA1(keyValueString).toString()
    return sign

  getPackage ->
    banktype = "WX"
    body = "fresh flower"
    partner = getPartnerId()
    out_trade_no = "OR1406180007"
    total_fee = "100"
    fee_type = "1"
    notify_url = "http://staging_wechat.zenhacks.org/wechats/"
    spbill_create_ip = "127.0.0.1"
    input_charset = "GBK"
    
    partnerKey = getPartnerKey()

    signString = "bank_type="+banktype+"&body="+body+"&fee_type="+fee_type+"&input_charset="+input_charset+"&notify_url="+notify_url+"&out_trade_no="+out_trade_no+"&partner="+partner+"&spbill_create_ip="+spbill_create_ip+"&total_fee="+total_fee+"&key="+partnerKey

    signValue = ("" + CryptoJS.MD5(signString)).toUpperCase()

    completeString = "bank_type="+encodeURIComponent(banktype)+"&body="+encodeURIComponent(body)+"&fee_type="+encodeURIComponent(fee_type)+"&input_charset="+encodeURIComponent(input_charset)+"&notify_url="+encodeURIComponent(notify_url)+"&out_trade_no="+encodeURIComponent(out_trade_no)+"&partner="+encodeURIComponent(partner)+"&spbill_create_ip="+encodeURIComponent(spbill_create_ip)+"&total_fee="+encodeURIComponent(total_fee)

    completeString = completeString + "&sign=" + signValue
    lastPackageString = completeString
    return completeString
