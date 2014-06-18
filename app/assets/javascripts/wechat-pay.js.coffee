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
    return "wxf8b4f85f3a794e77"

  getTimeStamp = ->
    timestamp = new Date().getTime()
    timestampstring = timestamp.toString()
    oldTimeStamp = timestampstring
    return timestampstring

  getNonceStr = ->
    nonceStr = ""
    rang = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    for i in [0..10]
      nonceStr += range.charAt(Math.floor(Math.random() * range.length))
    return nonceStr

  getSignType ->
    return "SHA1"

  getPaySign ->
    return "2Wozy2aksie1puXUBpWD8oZxiD1DfQuEaiC7KcRATv1Ino3mdopKaPGQQ7TtkNySuAmCaDCrw4xhPY5qKTBl7Fzm0RgR3c0WaVYIXZARsxzHV2x7iwPPzOz94dnwPWSn"

  getPackage ->
    banktype = "WX"
    body = "This is product description"
    partner =  "1900000109"
    out_trade_no = "OR1406180007"
    total_fee = "10000"
    fee_type = "1"
    notify_url = "http://www.hua.li"
    spbill_create_ip = "127.0.0.1"
    input_charset = "GBK"
    
    partnerKey = "8934e7d15453e97507ef794cf7b0519d"

    string1 = "bank_type="+banktype+"&body="+body+"&fee_type="+fee_type+"&input_charset="+input_charset+"&notify_url="+notify_url+"&out_trade_no="+out_trade_no+"&partner="+partner+"&spbill_create_ip="+spbill_create_ip+"&total_fee="+total_fee

    stringSignTemp =  string1+"&key="+partnerKey

    signValue =  (CryptoJS.MD5(stringSignTemp)).toUpperCase()

    string2 = "bank_type="+encodeURIComponent(banktype)+"&body="+encodeURIComponent(body)+"&fee_type="+encodeURIComponent(fee_type)+"&input_charset="+encodeURIComponent(input_charset)+"&notify_url="+encodeURIComponent(notify_url)+"&out_trade_no="+encodeURIComponent(out_trade_no)+"&partner="+encodeURIComponent(partner)+"&spbill_create_ip="+encodeURIComponent(spbill_create_ip)+"&total_fee="+encodeURIComponent(total_fee)

    completeString = string2 + "&sign="+signValue
    oldPackageString = completeString
                                                                                                                                             return completeString
