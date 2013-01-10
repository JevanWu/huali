#= require jquery.cookie
#= require underscore

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  $('#cart_amount span').text Cart.quantityAll()

  $('.purchase, .add_quantity, .reduce_quantity').click ->
    id = $(@).data('product')

    quantity =
      if $(@).attr('class').match('reduce')
      then  -1
      else 1

    Cart.update(id: id, quantity: quantity)

# product = { id: String, quantity: Integer }
# cart
#   'product_id': quantity
#   ...

window.Cart = {
  # FIXME should protect against bad 'cart' cookie during JSON.parse

  update: (product) ->
    # initialize cart
    cart = $.cookie('cart') || {}
    cart[product.id] = cart[product.id] || 0

    # update quantity of each products
    cart[product.id] += product.quantity

    # cleaning up invalid products
    for id, quantity of cart
      delete cart[id] if quantity <= 0

    $.cookie('cart', cart, path: '/')

  all: ->
    $.cookie('cart')

  get: (id) ->
    if id of $.cookie('cart')
      id: id, quantity: $.cookie('cart')[id]

  empty: ->
    $.removeCookie('cart', path: '/')

  quantityAll: ->
    cart = $.cookie('cart') || {}
    amounts = _.map(cart, (quantity, id) -> quantity)
    _.reduce(amounts, (sum, quan) -> sum + quan)
}
