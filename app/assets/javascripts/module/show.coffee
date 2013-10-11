$ ->
  #show.html 查看产品图片
  imgHeight = 515
  $("ul.thumb li").each (i,el) ->
    $(this).click ->
      imgIndex = $(this).index()
      $(".big-img-container").animate({top: -imgIndex*imgHeight})
      return
    return

  return