$ ->
  #提示信息关闭
  $(".error-tips b").click ->
  	$(".error-tips").hide()
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

  return