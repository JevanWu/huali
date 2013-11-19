$ ->
  $("#show-slide .container").width(620*$("#show-slide img").length)
  $("#show-slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return
  new Huali.component.Swipe
    node: $("#show-slide")
  return