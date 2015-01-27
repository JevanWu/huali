css =
  btnL: ".btn-left"
  btnR: ".btn-right"
  imgs: ".container"
  dots: ".slide-dot"
  cur: ".cur"

class Slide
  constructor: (@options) ->
    @node = @options.node
    @btnL = @node.find(css.btnL)
    @btnR = @node.find(css.btnR)
    @imgs = @node.find(css.imgs)
    @dots = @node.find(css.dots)

    @currentPage = 1
    @maxPage = @imgs.find("img").length #获取多少张轮播图，不一定固定

    @itemWidth = @imgs.find("img:eq(0)").width() #获取单张图片宽度，这个宽度到底多少，与这个组件无关

    @btnL.on("click",{dir:"left"},@onBtnClick)
    @btnR.on("click",{dir:"right"},@onBtnClick)
    @dots.on("click","a",@onDotClick)
  onBtnClick: (e) =>
    if e.data.dir is "left" and @currentPage isnt 1
      @changePage("+1")
    if e.data.dir is "right" and @currentPage isnt @maxPage
      @changePage("-1")
    return
  onDotClick: (e) =>
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
  move: (change) =>
    @imgs.stop(false,true).animate({"margin-left": parseInt(@imgs.css("margin-left")) + change*@itemWidth + "px"},"fast", "swing")
    @currentPage -= change
    @dots.find("a").removeClass("cur").eq(@currentPage-1).addClass("cur")
    return


window.Huali.component.Slide = Slide
