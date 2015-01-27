$ ->
  #fixed布局处理 设计要求好不合理 只能用JS来解决
  #又要从fixed布局改回去了，所以下面这段没用了
  ###if $(".error-tips").length isnt 0
    $(".error-tips,#l-fixed-area-container,#l-nav").wrapAll("<div id='l-fixed-area-item3'></div>")
  else
    $("#l-fixed-area-container,#l-nav").wrapAll("<div id='l-fixed-area-item2'></div>")###
  #提示信息关闭
  $(".error-tips b").click ->
  	#$(".error-tips").parent().attr("id","l-fixed-area-item2").end().remove()
    $(".error-tips").remove()
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

  # follow weixin popup
  $("*[data-action='follow-weixin']").click (e) ->
    e.preventDefault()
    $("#follow-pop-up .pop-up-content").show()
    $("#follow-pop-up").css("top",$(window).scrollTop() + $(window).height()/2 - $("#follow-pop-up").outerHeight() + "px").show()
    return
  # close weixin popup
  $("#follow-pop-up b").click (e) ->
    $("#follow-pop-up").hide()
    return
  # share product popup
  $("*[data-action='share-product']").click (e) ->
    e.preventDefault()
    product = $(this).data("product")
    $popup = $("#share-pop-up[data-product='#{product}']:first")

    $popup.find(".pop-up-content").show()
    $popup.css("top",$(window).scrollTop() + $(window).height()/4 - $popup.outerHeight() + "px").show()
    return
  # close share product popup
  $("#share-pop-up b").click (e) ->
    $(this).parent().hide()
    return

  #导航栏fixed
  $(window).scroll ->
    if $(window).scrollTop() >= 134
      if $("#l-nav").hasClass("nav-fixed") then return
      $("#l-nav").addClass("nav-fixed")
    else
      if not $("#l-nav").hasClass("nav-fixed") then return
      $("#l-nav").removeClass("nav-fixed")
    return

  #display qq customer service 
  $(window).scroll ->
    if $(".scroll-anchor").length
      windowTop = $(window).scrollTop()
      anchorTop = $(".scroll-anchor").offset().top
      if windowTop >= anchorTop
        if $(".scroll-object").hasClass("visible") then return
        $(".scroll-object").addClass("visible")
      else
        if not $(".scroll-object").hasClass("visible") then return
        $(".scroll-object").removeClass("visible")
      return
    else
      $("#qq-customer-service").addClass("visible")

  #scroll to
  $("#scrollTop").scrollTo()

  # show limited promo result popup
  popUp = ".limited-promo"
  $(popUp + " .pop-up-content").show()
  $(popUp).css("top",$(window).scrollTop() + $(window).height()/2 - $(popUp).outerHeight() + "px")
  $(popUp).css("left",$(window).width()/2 - $(popUp).width()/2 + "px").show()

  # close limited promo popup
  $(".limited-promo b").click (e) ->
    $(".limited-promo").hide()
    return

  return
