$ ->

  $("#slide .container").width($(window).width()*$("#slide img").length)
  $("#slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return

  new Huali.component.Slide
    node: $("#slide")

  #nav callout
  calloutItemSizeCollection = []
  edge = {}
  calloutDataCollection = ->
  calloutItemSizeCollection.length = 0
  $(".nav-callout-item").each (i,el) ->
    calloutItemSizeCollection.push
      width: $(this).outerWidth(true)
      height: $(this).outerHeight(true)
    $(this).addClass("is-hidden")
    edge =
      left: ($(window).width() - 940)/2
      right: ($(window).width() - 940)/2 + 940
    return
  calloutDataCollection()

  calloutMenu = new Huali.component.Callout
    node: $(".nav-item")
    calloutItemSizeCollection: calloutItemSizeCollection
    edge: edge
  
  $(window).resize ->
    calloutMenu = null
    edge = {}
    calloutDataCollection()
    calloutMenu = new Huali.component.Callout
      node: $(".nav-item")
      calloutItemSizeCollection: calloutItemSizeCollection
      edge: edge
    return

  return