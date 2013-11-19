﻿$ ->
  $("#slide .container").width($(window).width()*$("#slide img").length)
  $("#slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return

  bannerSlide = new Huali.component.Swipe
    node: $("#slide")

  #make auto slide
  _autoIndex = 1
  autoSlide = ->
    bannerSlide.dots.find("a").eq(_autoIndex).hammer().trigger("tap")
    _autoIndex++
    if _autoIndex >= 6 then _autoIndex = 0
    return

  setInterval(autoSlide,5000)

  return