$ ->
  $(".aston-martin").click ->
    $("li.active").removeClass("active")
    $(".aston-martin-video").parent().addClass("active")

  $("#slide .container").width($(window).width()*$("#slide img").length)
  $("#slide").find("img").each (i,el) ->
    $(el).width($(window).width())
    return

  bannerSlide = new Huali.component.Slide
    node: $("#slide")

  #make auto slide
  autoSlide = ->
    if bannerSlide.currentPage == bannerSlide.dots.find("a").length
      bannerSlide.dots.find("a").eq(0).click()
    else
      bannerSlide.dots.find("a").eq(bannerSlide.currentPage).click()

    return

  # cancel auto slide
  # setInterval(autoSlide,8000)

  #nav callout
  # calloutItemSizeCollection = []
  # edge = {}
  # calloutDataCollection = ->
  # calloutItemSizeCollection.length = 0
  # $(".nav-callout-item").each (i,el) ->
  #   calloutItemSizeCollection.push
  #     width: $(this).outerWidth(true)
  #     height: $(this).outerHeight(true)
  #   $(this).addClass("is-hidden")
  #   edge =
  #     left: ($(window).width() - 940)/2
  #     right: ($(window).width() - 940)/2 + 940
  #   return
  # calloutDataCollection()

  # calloutMenu = new Huali.component.Callout
  #   node: $(".nav-item")
  #   calloutItemSizeCollection: calloutItemSizeCollection
  #   edge: edge

  # $(window).resize ->
  #   calloutMenu = null
  #   edge = {}
  #   calloutDataCollection()
  #   calloutMenu = new Huali.component.Callout
  #     node: $(".nav-item")
  #     calloutItemSizeCollection: calloutItemSizeCollection
  #     edge: edge
  #   return

  return
