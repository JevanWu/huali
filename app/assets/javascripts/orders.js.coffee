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

    unless Cart.size() is 0

      if changeTo is 0
        $(@).parents("tr").remove()
      else
        $(@).siblings("input").val(changeTo)

      updatePrice()

      return false

  parseWithYen = (x) ->
    " ¥ "+x+" "
  updatePrice = ->
    priceSum = 0
    $('.item-table tr').slice(1,$('.item-table tr').size()-1).each(->
      pricePerItem = parseFloat($(this).children('.price').html().replace(/[^\d.]/g, ""))
      quantity = parseInt($(this).children('.quantity').children('input').val())
      priceSum += (priceSumItem = pricePerItem*quantity)
      $(this).children('.total').html(parseWithYen(priceSumItem.toFixed(2)))
      )
    $('.item-table tr').last().children().last().html(parseWithYen(priceSum.toFixed(2)))
    

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
