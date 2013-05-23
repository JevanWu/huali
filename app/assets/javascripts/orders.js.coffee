#= require jquery.cookie
#= require underscore
#= require_self
#= require prov_city_area_update

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  $('#cart_amount span').text Cart.quantityAll()

  $('.purchase').click ->
    pro = Cart.get $(@).data('product')
    Cart.update(id: pro.id, quantity: pro.quantity + 1)
    analytics.track 'Added Item To Cart',
      # FIXME added track for price / category
      product_id: pro.id
      quantity: pro.quantity

  freshCart = ->
    id = $(@).data('product')
    originQuantity = parseInt Cart.get(id)['quantity']
    action = $(@).attr('class').match(/(\w+)_quantity/)[1]

    changes =
      'add': originQuantity + 1,
      'reduce': originQuantity - 1,
      'empty': 0

    changeTo = changes[action]
    Cart.update(id: id, quantity: changeTo)

    if (Cart.size() == 0)
      location.reload()
      return false
    if (changeTo == 0)
      $(@).parents('tr').remove()
      updateTable('.item-table')
      return false

    $(@).siblings('input').val(changeTo)
    updateItemRow($(@).parents('tr'))
    return false

  $('.item-table').on 'click', '.add_quantity, .reduce_quantity, .empty_quantity', freshCart

  updateItemRow = (row) ->
    price = $('.price', row).data('price')
    quantity = parseInt $('.quantity > input', row).val()
    total = price * quantity
    $('.total', row).data('total', total).html toCurrency(total.toFixed(2))
    updateTable('.item-table')

  updateTable = (tablename) ->
    total = _.reduce($("#{tablename} tbody tr"),
      ((sum, row) ->
        rowTotal = parseInt $('.total', row).data('total')
        sum + rowTotal)
      , 0)

    $("#{tablename} tfoot tr td:last").html toCurrency(total)
    updateCartAmount()

  appendToTable = (tablename, content) ->
    $("#{tablename} tbody").append(content)

  toCurrency = (x, unit = '¥') ->
    " #{unit} #{x} "

  updateCartAmount = ->
    $('#basket #cart_amount span').html Cart.quantityAll()

  $('.suggestion-cell').hover(
    ->
      $(@).find('.suggestion-click-to-cart').css('opacity',0).css('visibility','visible').fadeTo(400,1)
    ->
      $(@).find('.suggestion-click-to-cart').fadeTo(400,0)
    )

  $('.suggestion-click-to-cart > a').click ->
    productId = $(@).data('product-id')
    if Cart.get(productId).quantity is 0
      Cart.update(id: productId, quantity: 1)

      table = if $('.suggestion-on-current').length is 0 then '.side-table' else '.item-table'

      appendToTable(table, $(@).data('field-for-table'))
      updateTable(table)

    return false

# product = { id: String, quantity: Integer }
# cart
#   'product_id': quantity
#   ...

window.Cart = {
  # FIXME should protect against bad 'cart' cookie during JSON.parse

  size: ->
    _.size $.cookie('cart')

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

  get: (id) ->
    quantity = $.cookie('cart') && $.cookie('cart')[id] || 0
    { id: id, quantity: quantity }

  empty: ->
    $.removeCookie('cart', path: '/')

  quantityAll: ->
    cart = $.cookie('cart')
    return 0 if _.size($.cookie('cart')) is 0
    amounts = _.map(cart, (quantity, id) -> quantity)
    total = _.reduce(amounts, (sum, quan) -> sum + quan)
}
