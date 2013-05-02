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

  updateRowCurrent = (row) ->
    price = row.children('.price').data('price')
    quantity = parseInt(row.children('.quantity').children('input').val())
    total = price*quantity
    row.children('.total').data('total',total).html(number_to_currency(total.toFixed(2)))
    updateTableCurrent()

  updateTableCurrent = ->
    sum = 0  
    $('.item-table tbody tr').each(->
      sum += $(this).children('.total').data('total'))
    $('.item-table tfoot tr td:last').html(number_to_currency(sum.toFixed(2)))
    update_basket_cart_amount()

  updateTableCheckout = ->
    sum = 0
    $('.side-table tbody tr .total').each(->
      sum += $(@).data('total')
      )
    $('.side-table tfoot tr td:last').html(number_to_currency(sum.toFixed(2)))
    update_basket_cart_amount()

  triggersClick = ->
    id = $(@).data('product')
    quantity_ori = Cart.get(id)['quantity']
    action = $(@).attr('class').match(/(\w+)_quantity/)[1]

    changes = { 'add': 1, 'reduce': -1, 'empty': -quantity_ori }
    changeTo = quantity_ori + changes[action]
    Cart.update(id: id, quantity: changeTo)

    if (Cart.size() == 0)
      location.reload()
      return false
    if (changeTo == 0)
      $(@).parents("tr").remove()
      updateTableCurrent()
      return false
    $(@).siblings("input").val(changeTo)

    updateRowCurrent($(@).parents('tr'))

    return false

  $('.add_quantity, .reduce_quantity, .empty_quantity').click(triggersClick)

  append_to_cart_table_current = (content) ->
    $(".cart-table tbody").append(content)

  append_to_cart_table_checkout = (content) ->
    $(".side-table tbody").append(content)

  number_to_currency = (x, unit = '¥') ->
    " #{unit} x "

  update_basket_cart_amount = ->
    $("#basket #cart_amount span").html(Cart.quantityAll())

  $('.suggestion-cell').hover(
    ->
      $(@).find('.suggestion-click-to-cart').css('opacity',0).css('visibility','visible').fadeTo(400,1)
    ->
      $(@).find('.suggestion-click-to-cart').fadeTo(400,0)
    )

  $('.suggestion-click-to-cart > a').click(
    ->
      pid = $(@).data('product-id')
      if (Cart.get(pid).quantity != 0)
        return false
        # FIXME, add logic for if already in cart
          # method 1, add quantity in cart
          # method 2, after click-to-cart, fadeOut and fadeIn another image
      else
        Cart.update(id: pid, quantity: 1)

        if $(".suggestion-on-current").length is 0
          append_to_cart_table_checkout($(@).data('field-for-table'))
          updateTableCheckout()
        else
          append_to_cart_table_current($(@).data('field-for-table'))
          updateTableCurrent()
          $('.add_quantity, .reduce_quantity, .empty_quantity').click(triggersClick)

      return false
  )

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
