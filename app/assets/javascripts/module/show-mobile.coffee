$ ->
  ###
  $("#show-slide .container").width(620*$("#show-slide img").length)
  $("#show-slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return
  new Huali.component.Swipe
    node: $("#show-slide")
  ###

  window.homeSwipe = new Swipe(document.getElementById('show-slide'), {
    speed: 400,
    auto: 3000,
    callback: (index, ele) ->
      $(".slide-dot a").removeClass("cur")
      $(".slide-dot a").eq(index).addClass("cur")
      return
  })

  return