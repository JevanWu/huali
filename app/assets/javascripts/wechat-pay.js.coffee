$(document).ready ->
  $("a#getBrandWCPayRequest").click ->
    alert "getBrand"
    # WeixinJSBridge.invoke('getBrandWCPayRequest', {
    #   # "appId": getAppId()
    #   # "timeStamp": getTimeStamp()
    #   # "nonceStr": getNonceStr()
    #   # "package": getPackage()
    #   # "signType": getSignType()
    #   # "paySign": getPaySign()
    #   }, (res) ->
    #     if(res.err_msg == "get_brand_wcpay_request:ok"){
    #     }
    # )

