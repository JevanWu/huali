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

  bindTriggersClick = ->
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
    # update_basket_cart_amount()

    unless Cart.size() is 0

      if changeTo is 0
        $(@).parents("tr").remove()
      else
        $(@).siblings("input").val(changeTo)

      update_price_current()

      return false

  $('.add_quantity, .reduce_quantity, .empty_quantity').one(click, bindTriggersClick)

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
        # FIXME, add logic for if already in cart
          # method 1, add quantity in cart
          # method 2, after click-to-cart, fadeOut and fadeIn another image        
      else
        Cart.update(id: pid, quantity: 1)

        append_to_cart_table_current($(@).data('field-for-table'))
        update_price_current()

        append_to_cart_table_checkout($(@).data('field-for-table'))
        update_price_checkout()

        update_basket_cart_amount()

        $('.add_quantity, .reduce_quantity, .empty_quantity').one(click, bindTriggersClick)

      return false
  )

  append_to_cart_table_current = (content) ->
    $(".cart-table tbody").append(content)

  append_to_cart_table_checkout = (content) ->
    $(".side-table tbody").append(content)
    
  number_to_currency = (x, unit="¥") ->
    " " + unit + " " + x + " "

  update_price_current = ->
    priceSum = 0
    $('.item-table tr').slice(1,$('.item-table tr').size()-1).each(->
      pricePerItem = parseFloat($(this).children('.price').html().replace(/[^\d.]/g, ""))
      quantity = parseInt($(this).children('.quantity').children('input').val())
      priceSum += (priceSumItem = pricePerItem*quantity)
      $(this).children('.total').html(number_to_currency(priceSumItem.toFixed(2)))
      )
    $('.item-table tr').last().children().last().html(number_to_currency(priceSum.toFixed(2)))
    
  update_price_checkout = ->
    priceSum = 0
    $('.side-table tbody tr .total').each(->
      priceSum += parseFloat($(@).html().replace(/[^\d.]/g, ""))
      )
    $('.side-table tfoot tr td:last').html(number_to_currency(priceSum.toFixed(2)))

  update_basket_cart_amount = ->
    $("#basket #cart_amount span").html(Cart.size())

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
