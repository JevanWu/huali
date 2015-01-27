css =
  minus: ".minus"
  plus: ".plus"
  drop: ".drop"
  input: ".op input"
  price: ".price"
  totalNum: ".total-num"
  totalPrice: ".total-price"
  cartItem: ".cart-product-item"
  empty: ".empty"
  notEmpty: ".not-empty"
  isHidden: "is-hidden"


class GoodsEditMobile
  constructor: (@options) ->
    @node = @options.node

    @minusBtn = @node.find(css.minus)
    @plusBtn = @node.find(css.plus)
    @dropBtn = @node.find(css.drop)

    @numInput = @node.find(css.input)
    @price = @node.find(css.price)
    @num = @price.siblings("em")

    @totalNum = $(css.totalNum)
    @totalPrice = $(css.totalPrice)

    @unitPrice = @getPrice() / @getNum()

    @minusBtn.hammer().on("tap",@onMinus)
    @plusBtn.hammer().on("tap",@onPlus)
    @dropBtn.hammer().on("tap",@onDrop)

    Huali.Event.on("totalChange",@onTotalChange)
    Huali.Event.on("totalEmpty",@onTotalEmpty)

  getNum: ->
    parseInt(@numInput.val())

  setNum: (value) ->
    if value is 0 then return

    previous = @getNum() #for total calculating

    @numInput.val(value)
    @num.text(value)
    @setPrice(@unitPrice*value)

    numChange = @getNum() - previous
    priceChange = (@getNum() - previous) * @unitPrice
    Huali.Event.emit("totalChange", numChange, priceChange)
    return

  setPrice: (price) ->
    @price.text("￥"+price)
    return

  getPrice: ->
    parseInt(@price.text().slice(1))

  onMinus: =>
    @setNum(@getNum()-1)
    return

  onPlus: =>
    @setNum(@getNum()+1)
    return

  onDrop: =>
    @node.remove()
    Huali.Event.emit("totalChange", -@getNum(), -@getPrice())
    if $(css.cartItem).length is 0
      Huali.Event.emit("totalEmpty")
    return

  onTotalChange: (numChange,priceChange) =>
    @totalNum.text(parseInt(@totalNum.text()) + numChange)
    @totalPrice.text("￥" + (parseInt(@totalPrice.text().slice(1)) + priceChange))
    return

  onTotalEmpty: =>
    $(css.notEmpty).addClass(css.isHidden)
    $(css.empty).removeClass(css.isHidden)
    return


window.Huali.component.GoodsEditMobile = GoodsEditMobile