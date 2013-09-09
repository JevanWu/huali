class Huali
  constructor: ->
    return

class Event
  constructor: ->
    @constructor = "Event"
    return

  @eventListners: ->
    {}

  @emit: (eventName) =>
    theArgs = Array.prototype.slice.call(arguments,arguments.callee.length)
    @eventListners[eventName].apply(this,theArgs);
    return

  @on: (eventName, fn) =>
    if typeof eventName isnt "string"
      throw TypeError("The custom event name must be a string!")
    this.eventListners[eventName] = fn
    return

  @off: (eventName) =>
    delete this.eventListners[eventName]
    return

class Cookie
  constructor: ->
    @constructor = "Cookie"
    return

  @setCookie: (name, value, expires) ->
    expiresDate = new Date().getDate() + expires
    document.cookie = name + "=" + value + ";expires=" + expiresDate
    return

  @getCookie: (name) ->
    arr = document.cookie.split(";")
    for coo,i in arr
      arr2=arr[i].split("=")
      if arr2[0] is name then return aa2[i]
    ""
  @removeCookie: (name) ->
    setCookie(name, "", -1)
    return

class component
  constructor: ->
    return

# product = { id: String, quantity: Integer }
# cart
#   'product_id': quantity
#   ...

class Cart
  # FIXME should protect against bad 'cart' cookie during JSON.parse

  @product_ids: ->
    _.map($.cookie('cart'), (quantity, id) -> id)

  @size: ->
    _.size $.cookie('cart')

  @update: (product) ->
    # initialize cart
    cart = $.cookie('cart') || {}
    cart[product.id] = cart[product.id] || 0

    # update quantity of each products
    cart[product.id] = product.quantity

    # cleaning up invalid products
    for id, quantity of cart
      delete cart[id] if quantity <= 0

    $.cookie('cart', cart, path: '/')

  @get: (id) ->
    quantity = $.cookie('cart') && $.cookie('cart')[id] || 0
    { id: id, quantity: quantity }

  @empty: ->
    $.removeCookie('cart', path: '/')

  @quantityAll: ->
    cart = $.cookie('cart')
    return 0 if _.size($.cookie('cart')) is 0
    amounts = _.map(cart, (quantity, id) -> quantity)
    total = _.reduce(amounts, (sum, quan) -> sum + quan)


Huali.Event = Event
Huali.Cookie = Cookie

Huali.component = component
Huali.Cart = Cart

window.Huali = Huali
