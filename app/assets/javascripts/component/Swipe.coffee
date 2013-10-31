css = 
  btnL: ".btn-left"
  btnR: ".btn-right"
  imgs: ".container"
  dots: ".slide-dot"
  cur: ".cur"

class Swipe
  constructor: (@options) ->
    @node = @options.node
    @btnL = @node.find(css.btnL)
    @btnR = @node.find(css.btnR)
    @imgs = @node.find(css.imgs)
    @dots = @node.find(css.dots)

    @currentPage = 1
    @maxPage = @imgs.find("img").length #获取多少张轮播图，不一定固定

    @itemWidth = @imgs.find("img:eq(0)").width() #获取单张图片宽度，这个宽度到底多少，与这个组件无关

    @btnL.hammer().on("tap",{dir:"left"},@onBtnClick)
    @btnR.hammer().on("tap",{dir:"right"},@onBtnClick)
    @dots.hammer().on("tap","a",@onDotClick)

    #比PC上的Slide多了swipe
    @node.hammer().on("swipeleft",{dir:"left"},@swipe)
    @node.hammer().on("swiperight",{dir:"right"},@swipe)

  onBtnClick: (e) =>
    e.stopPropagation()
    if e.data.dir is "left" and @currentPage isnt 1
      @changePage("+1")
    if e.data.dir is "right" and @currentPage isnt @maxPage
      @changePage("-1")
    return
  onDotClick: (e) =>
    e.stopPropagation()
    return if $(e.currentTarget).hasClass(css.cur)
    targetPage = @dots.find("a").index($(e.currentTarget))
    @changePage(targetPage)
    return
  changePage: (par) ->
    if typeof par is "string"
      @move(parseInt(par))
    if typeof par is "number"
      @move(@currentPage-par-1)
    return
  move: (change) ->
    endPos = parseInt(@imgs.css("margin-left")) + change*@itemWidth + "px"
    @imgs.animate({"margin-left":endPos},"fast")
    @currentPage -= change
    @dots.find("a").removeClass("cur").eq(@currentPage-1).addClass("cur")
    return
  swipe: (e) =>
    e.data.dir is "left" and @btnR.hammer().trigger("tap")
    e.data.dir is "right" and @btnL.hammer().trigger("tap")
    return

window.Huali.component.Swipe = Swipe