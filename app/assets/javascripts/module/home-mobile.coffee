$ ->
  $("#slide .container").width($(window).width()*$("#slide img").length)
  $("#slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return

  new Huali.component.Swipe
    node: $("#slide")

  return