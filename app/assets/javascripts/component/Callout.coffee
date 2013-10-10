#$(".nav-item")
css =
  callout: ".nav-callout"
  cur: "cur"
  calloutItem: ".nav-callout-item"
  calloutContainer: ".nav-callout-container"

class Callout
  constructor: (@options) ->
    @node = @options.node

    #get size/position data
    @calloutItemSizeCollection = @options.calloutItemSizeCollection
    @edge = @options.edge

    @end = true

    @node.find("li:not('.last')").on("mouseover", @onMouseover)

    $(document).on("mouseover",@onDocMouseover)

  getPos: (which,$trigger) ->
    #formula
    #$trigger.offset().left + $trigger.width()/2 = $tar.offset().left(求这个值) + @calloutItemSizeCollection[which].width/2
    tarOffsetLeft = $trigger.offset().left + $trigger.width()/2 - @calloutItemSizeCollection[which].width/2
    if tarOffsetLeft < @edge.left then tarOffsetLeft = @edge.left
    if tarOffsetLeft + @calloutItemSizeCollection[which].width > @edge.right then tarOffsetLeft = (@edge.right-@calloutItemSizeCollection[which].width)
    tarOffsetLeft

  horizontalMove: ($tar,which,$trigger,change) ->
    @end = false
    if change is "width"
      $tar.stop(false,true).animate({left: @getPos(which,$trigger),width: @calloutItemSizeCollection[which].width},200, ->
        @begin = true
        return
        )
    else if change is "both"
       $tar.stop(false,true).animate({left: @getPos(which,$trigger),width: @calloutItemSizeCollection[which].width,height:@calloutItemSizeCollection[which].height},200, ->
        @begin = true
        return
        )
    else if change is "height"
       $tar.stop(false,true).animate({left: @getPos(which,$trigger),height: @calloutItemSizeCollection[which].height},200, ->
        @begin = true
        return
        )
    else
      $tar.stop(false,true).animate({left: @getPos(which,$trigger)},200, ->
        @begin = true
        return
        )
    return

  onMouseover: (e) =>
    $target = $(css.calloutContainer)
    #arrow
    which = $(e.currentTarget).index()
    @node.find("li").removeClass(css.cur)
    $(e.currentTarget).addClass(css.cur)
    if $target.css("visibility") is "visible"
      #display correct menu
      $(css.calloutItem).addClass("is-hidden")#这句是临时的，随后放到document的over事件中全部加上is-hidden
      $(css.calloutItem).eq(which).removeClass("is-hidden")
      #do width change
      if @calloutItemSizeCollection[which].width isnt $(css.calloutContainer).width()
        change = "width"
        if @calloutItemSizeCollection[which].height isnt $(css.calloutContainer).height()
          change = "both"
      else if @calloutItemSizeCollection[which].height isnt $(css.calloutContainer).height()
        change = "height"
      else
        change = "no"
      #do horizontal animate
      @horizontalMove($target,which,$(e.currentTarget),change)
    else
      #first come out
      #$target.width(1).height(1)
      $target.height(1).width(@calloutItemSizeCollection[which].width)
      $target.css({left: @getPos(which,$(e.currentTarget)),"visibility": "visible"})
      $(css.calloutItem).eq(which).removeClass("is-hidden")
      $target.stop(false,true).animate({
        #width: @calloutItemSizeCollection[which].width
        height: @calloutItemSizeCollection[which].height
        })
    return

  onDocMouseover: (e) =>
    detect1 = $(e.target).hasClass("nav-item") is false
    detect2 = $(e.target).parents(".nav-item").length is 0
    detect3 = $(e.target).hasClass("nav-callout-container") is false
    detect4 = $(e.target).parents(".nav-callout-container").length is 0
    if detect1 and detect2 and detect3 and detect4
      $(css.calloutContainer).css({"visibility": "hidden", "left": "0"}) #callout init
      @node.find("li").removeClass(css.cur)
    return

window.Huali.component.Callout = Callout