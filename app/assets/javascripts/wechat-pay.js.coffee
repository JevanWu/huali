$(document).ready ->
  $("button#getBrandWCPayRequest").click ->
    WeixinJSBridge.invoke('getBrand', {
      # "appId": getAppId()
      # "timeStamp": getTimeStamp()
      # "nonceStr": getNonceStr()
      # "package": getPackage()
      # "signType": getSignType()
      # "paySign": getPaySign()
      alert "getBrand"
      }, (res) ->
        if(res.err_msg == "get_brand_wcpay_request:ok"){
        }
    )

