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

  $('.suggestion-cell').hover(
    ->
      $(@).children('.suggestion-click-to-cart').css('opacity',0).css('visibility','visible').fadeTo(400,1)
    ->
      $(@).children('.suggestion-click-to-cart').fadeTo(400,0)
    )


  $('.suggestion-click-to-cart > a').click(
    ->
      pid = $(@).data('product-id')
      pro = Cart.get pid
      if (Cart.get(pid).quantity != 0)
        # FIXME, add logic for if already in cart
          # method 1, add quantity in cart
          # method 2, after click-to-cart, fadeOut and fadeIn another image        
      else
        Cart.update(id: pro.id, quantity: pro.quantity + 1)
        dataClone = $(@).data()
        newimg = $(@).parent().siblings("a").html().replace("width=\"100\"","width=\"150\"")
        dataClone['img'] = newimg
        dataClone['ahref'] = $(@).attr('href')
        append_to_cart_table dataClone
      return false
  )

  append_to_cart_table = (p) ->
    content = "<tr>" +
    "<td class=\"image\">" + p.img + "</td>" +
    "<td class=\"name\"><a href=\"" + p.ahref + "\">" + p.productName + "</a></td>"+
    "<td class=\"price\" data-price=\"" + p.productPrice + "\">¥ " + p.productPrice + "</td>"+
    "<td class=\"quantity\">"+
      "<a href=\"/orders/current\" class=\"add_quantity trigger\" data-product='"+p.productId.toString()+"'><i class=\"icon-plus\"></i></a>"+
      "<input type=\"text\" value=\"1\">"+
      "<a href=\"/orders/current\" class=\"reduce_quantity trigger\" data-product='"+p.productId.toString()+"'><i class=\"icon-minus\"></i></a>"+
      "<a href=\"/orders/current\" class=\"empty_quantity trigger\" data-product='"+p.productId.toString()+"'><i class=\"icon-trash\"></i></a>"+
    "</td>"+
    "</tr>"
    $(".cart-table tbody").append(content)

  number_to_currency = (x, unit) ->
    " " + unit + " " + x + " "

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
