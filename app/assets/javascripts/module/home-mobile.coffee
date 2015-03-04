$ ->
  ###
  $("#slide .container").width($(window).width()*$("#slide img").length)
  $("#slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return
  ###

  window.homeSwipe = new Swipe(document.getElementById('slide'), {
    speed: 400,
    auto: 6000,
    callback: (index, ele) ->
      $(".slide-dot a").removeClass("cur")
      $(".slide-dot a").eq(index).addClass("cur")
      return
  })

  ###bannerSlide = new Huali.component.Swipe
    node: $("#slide")###

  #make auto slide
  ###_autoIndex = 1
  autoSlide = ->
    bannerSlide.dots.find("a").eq(_autoIndex).hammer().trigger("tap")
    _autoIndex++
    if _autoIndex >= 6 then _autoIndex = 0
    return

  setInterval(autoSlide,5000)###

  return
