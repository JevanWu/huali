$ ->
  #my-order.html tooltip
  toggleClass = "is-hidden"
  $toggleTar = $(".viewDetail")
  $("#tooltip-viewDetail").hover ->
    $toggleTar.removeClass(toggleClass)
    return
  ,->
    $toggleTar.addClass(toggleClass)
    return

  return