#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN
#= require jquery.cookie
#= require underscore

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  $('#cart_amount span').text Cart.quantityAll()

  datePicker = $('.datepicker')

  if datePicker.length > 0
    datePicker.datepicker(
        gotoCurrent: true
        minDate: '+1D'
        maxDate: '+1M'
    )

  $('.purchase').click ->
    id = $(@).data('product')
    Cart.update(id: id, quantity: 1)

  $('.add_quantity, .reduce_quantity, .empty_quantity').click ->
    id = $(@).data('product')
    quantity = Cart.get(id)['quantity']
    action = $(@).attr('class').match(/(\w+)_quantity/)[1]

    changeTo = switch action
      when 'add'
        quantity + 1
      when 'reduce'
        quantity - 1
      when 'empty'
        0
      else
        quantity

    Cart.update(id: id, quantity: changeTo)

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
    cart[product.id] = product.quantity

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
    cart = $.cookie('cart')
    return 0 if _.size($.cookie('cart')) is 0
    amounts = _.map(cart, (quantity, id) -> quantity)
    total = _.reduce(amounts, (sum, quan) -> sum + quan)
}
