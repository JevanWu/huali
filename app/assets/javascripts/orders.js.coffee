#= require_self

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  #查看某种花时加入购物车的操作
  $('a.add-btn, button.add-btn').click (e) ->
    link = $(@)
    pro = Cart.get link.data('product')
    Cart.update(id: pro.id, quantity: pro.quantity + 1)

  $('#quick_purchase_form').on 'ajax:beforeSend', ->
    $('.loading').show()
  $('#quick_purchase_form').on 'ajax:complete', ->
    $('.loading').hide()

  $('#quick_purchase_form #quick_purchase_form_expected_date').change ->
    $('#quick_purchase_form').submit()

  $('#product-list').on 'click', 'a.quick-purchase-add-btn', (e) ->
    link = $(@)
    proid = link.data('product')
    pro = Cart.get proid
    Cart.update(id: pro.id, quantity: pro.quantity + 1)
    $("a#quick-purchase-#{proid}").replaceWith( "<p style='margin-top: 15px'>已添加</p>" )
    proCount = Number($('a.cart').text().split('')[1]) + Number('1')
    $("a.cart").html("(" + proCount + ")")


    #调试代码别忘了注释
    ###analytics.track 'Added Item To Cart',
      # FIXME added track for price / category
      category: 'order'
      product_id: pro.id
      quantity: pro.quantity###

    # ported from https://github.com/segmentio/analytics.js/blob/master/src/analytics.js
    # delayed a bit to shot the tracking out
    # To justify us preventing the default behavior we must:

    # * Have an `href` to use.
    # * Not have a `target="_blank"` attribute.
    # * Not have any special keys pressed, because they might be trying to
      # open in a new tab, or window, or download.

    # This might not cover all cases, but we'd rather throw out an event
    # than miss a case that breaks the user experience.
    if link.attr('href') && link.attr('target') != '_blank' && !isMeta(e)
      e.preventDefault()
      # Navigate to the url after just enough of a timeout.
      followLink = -> window.location.href = link.attr('href')
      setTimeout(followLink, 300)

  freshCart = (e) ->
    e.preventDefault()
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
      $(@).parents('.item-table').remove()
      updateTable('.item-table')
      return false

    $(@).siblings('input').val(changeTo)
    updateItemRow($(@).parents('.item-table'))
    return false

  #增加减少删除
  $('.item-table').on 'click', '.add_quantity, .reduce_quantity, .empty_quantity', freshCart

  updateCartQuantityText = (quantity) ->
    $('.cart:first').text "(#{quantity})"

  updateItemRow = (row) ->
    price = $('.price', row).data('price')
    quantity = parseInt $('.quantity input', row).val()
    total = price * quantity
    row.data('total', total)
    updateTable('.item-table')
    return

  updateTable = (tablename) ->
    ###total = _.reduce($("#{tablename} tbody tr"),
      ((sum, row) ->
        rowTotal = parseInt $('.total', row).data('total')
        sum + rowTotal)
      , 0)###
    total = _.reduce($("#{tablename}"),(sum,row) ->
      rowTotal = parseInt $(row).data('total')
      sum + rowTotal
    ,0)
    $(".total-price").html toCurrency(total)
    $(".checkout .subtotal i").text(Cart.quantityAll())

    updateCartQuantityText(Cart.quantityAll())

  appendToTable = (tablename, content) ->
    $("#{tablename} tbody").append(content)

  toCurrency = (x, unit = '¥') ->
    " #{unit} #{x} "

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

  #购物车的总商品数量

  updateCartQuantityText(Cart.quantityAll())


# product = { id: String, quantity: Integer }
# cart
#   'product_id': quantity
#   ...

window.Cart = {
  # FIXME should protect against bad 'cart' cookie during JSON.parse

  product_ids: ->
    _.map($.cookie('cart'), (quantity, id) -> id)

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

    $.cookie('cart', cart, { expires: 1, path: '/'} )

  get: (id) ->
    quantity = $.cookie('cart') && $.cookie('cart')[id] || 0
    { id: id, quantity: quantity }

  empty: ->
    $.removeCookie('cart', { path: '/' } )

  quantityAll: ->
    cart = $.cookie('cart')
    return 0 if _.size($.cookie('cart')) is 0
    amounts = _.map(cart, (quantity, id) -> quantity)
    total = _.reduce(amounts, (sum, quan) -> sum + quan)
}

# ported from https://github.com/segmentio/is-meta
window.isMeta = (e) ->
  if (e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)
    return true

  # Logic that handles checks for the middle mouse button, based
  # on [jQuery](https://github.com/jquery/jquery/blob/master/src/event.js#L466).
  which = e.which; button = e.button

  if (!which && button != undefined)
    return (!button & 1) && (!button & 2) && (button & 4)
  else if (which == 2)
    return true

  return false
#查询邮编
$ ->
  $('#query-postcode').click (event) ->
    href = "http://opendata.baidu.com/post/s?ie=UTF-8&wd="

    province = $('select[id$=_province_id] option:selected').text()
    city = $('select[id$=_city_id] option:selected').text()
    area = $('select[id$=_area_id] option:selected').text()
    address = $('textarea[id$=_address]').val()

    if province != "请选择" and city != "请选择" and city != "请选择城市"
      region = "#{province} #{city}"

      if area.length > 0 and area != "请选择"
        region += " #{area}"

      if address.length > 0
        region += " #{address}"

      #$(this).attr('href', href + region)
      window.open('javascript:window.name;', '<script>location.replace("'+ href + region+'")<\/script>');
    else
      event.preventDefault()

  $('button#gift-card-info-trigger').click (event) ->
    event.preventDefault()
    text = $(this).text()
    if text == "添加贺卡内容"
      $(this).text("隐藏贺卡内容")
    else
      $(this).text("添加贺卡内容")

    $('#gift-card-info').toggle('slow')
