$ ->
  #cate.html tab切换
  $(".tabs a").each (i,el) ->
    $(this).click ->
      tabIndex = $(this).index() - 1
      $(".cate-list-style1,.cate-list-style2").addClass("is-hidden").eq(tabIndex).removeClass("is-hidden")
      return
    return
  

  return