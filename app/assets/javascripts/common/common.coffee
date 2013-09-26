$ ->
  #fixed布局处理 设计要求好不合理 只能用JS来解决
  if $(".error-tips").length isnt 0
    $(".error-tips,#l-fixed-area-container,#l-nav").wrapAll("<div id='l-fixed-area-item3'></div>")
  else
    $("#l-fixed-area-container,#l-nav").wrapAll("<div id='l-fixed-area-item2'></div>")
  #提示信息关闭
  $(".error-tips b").click ->
  	$(".error-tips").parent().attr("id","l-fixed-area-item2").end().remove()
  	return
  #导航栏下拉购物车
  $(".cart-li-preview").hover ->
    $(this).find("i").show()
    $(this).find(".cart-preview-container").show()
    return
  ,->
    $(this).find("i").hide()
    $(this).find(".cart-preview-container").hide()
    return

   #导航栏下拉个人设置
  $(".personal-account").hover ->
    $(this).find("i").show()
    $(this).find(".profile").show()
    return
  ,->
    $(this).find("i").hide()
    $(this).find(".profile").hide()
    return

  #banner
  $("#banner .close").click (e)->
    e.preventDefault()
    $("#banner").parent().remove()
    return

  #placeholder
  $(".placeholder input[type='text']").focus ->
    $(".placeholder label").hide()
    return
  $(".placeholder label").click ->
    $(".placeholder input[type='text']").focus()
    return
  $(".placeholder input[type='text']").blur ->
    if $(this).val() is ""
      $(".placeholder label").show()
    return

  #share
  $("*[data-action='follow-weixin']").click (e) ->
    e.preventDefault()
    $(".QR").show()
    $(".display-share").hide()
    $("#pop-up").css("top",$(window).scrollTop() + $(window).height()/2 - $("#pop-up").outerHeight() + "px").show()
    return
  #close
  $("#pop-up b").click (e) ->
    $("#pop-up").hide()
    return
  #add-to-cart
  $(".add-to-share").click (e) ->
    $(".QR").hide()
    $(".display-share").show()
    $("#pop-up").css("top",$(window).scrollTop() + $(window).height()/2 - $("#pop-up").outerHeight() + "px").show()
    return

  return