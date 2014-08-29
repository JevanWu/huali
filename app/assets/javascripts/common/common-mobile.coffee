$ ->
  $("a.nav").hammer().on("tap", (e) ->
    $("nav").slideToggle()
    return
  )

  $(".error-tips b").click ->
    $(this).parent().remove()
    return

  $(document).ready ->
    $(document).addEventListener('WeixinJSBridgeReady', onBridgeReady(), false)
  return
