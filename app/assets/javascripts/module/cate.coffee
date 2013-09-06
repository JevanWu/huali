$ ->
  #cate.html tab切换
  $(".tabs a").each (i,el) ->
    $(this).click ->
      tabIndex = $(this).index() - 1
      $("ul.row-item,.best-products").addClass("is-hidden").eq(tabIndex).removeClass("is-hidden")
      return
    return
  

  return