#= require jquery.cookie

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  $('.purchase').click ->
    $(@).data('product')
    return false

# product = { id: String, quantity: Integer }
# cart
#   'product_id': quantity
#   ...

window.Cart = {
  update: (product) ->
    # initialize cart
    cart = $.cookie('cart') || {}
    cart[product.id] = cart[product.id] || 0

    # update quantity of each products
    cart[product.id] += product.quantity

    # cleaning up invalid products
    for id, quantity in cart
      delete cart[id] if quantity <= 0

    $.cookie('cart', cart, path: '/')

  all: ->
    $.cookie('cart')

  get: (id) ->
    if id of $.cookie('cart')
      id: id, quantity: $.cookie('cart')[id]

  empty: ->
    $.removeCookie('cart', path: '/')
}
