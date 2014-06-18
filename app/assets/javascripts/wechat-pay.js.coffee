$(document).ready ->
  $("#getBrandWCPayRequest").click ->
    alert "getBrand"
    # WeixinJSBridge.invoke('getBrand', {
      # "appId": getAppId
      # "timeStamp": getTimeStamp
      # "nonceStr": getNonceStr
      # "package": getPackage()
      # "signType": getSignType()
      # "paySign": getPaySign()
    #   }, (res) ->
    # )

  getAppId = ->
    "wxf8b4f85f3a794e77"

  getTimeStamp = ->
    timestamp = new Date().getTime()
    timestampstring = timestamp.toString()
    oldTimeStamp = timestampstring
    return timestampstring

  getNonceStr = ->


