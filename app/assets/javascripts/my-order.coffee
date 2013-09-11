$ ->
  #my-order.html tooltip
  toggleClass = "is-hidden"
  $(".tooltip-viewDetail").hover ->
    $(this).parent().next().removeClass(toggleClass)
    return
  ,->
    $(this).parent().next().addClass(toggleClass)
    return

  return