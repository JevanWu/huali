#= require jquery.cookie
#= require underscore
#= require_self

$ ->
  # turn on JSON parsing in $.cookie
  $.cookie.json = true

  $('#cart_amount span').text Huali.Cart.quantityAll()

  $('.add-to-cart .add-btn').click (e) ->
    link = $(@)
    pro = Huali.Cart.get link.data('product')
    Huali.Cart.update(id: pro.id, quantity: pro.quantity + 1)
    analytics.track 'Added Item To Cart',
      # FIXME added track for price / category
      category: 'order'
      product_id: pro.id
      quantity: pro.quantity

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

  $('.suggestion-cell').hover(
    ->
      $(@).find('.suggestion-click-to-cart').css('opacity',0).css('visibility','visible').fadeTo(400,1)
    ->
      $(@).find('.suggestion-click-to-cart').fadeTo(400,0)
    )

  $('.suggestion-click-to-cart > a').click ->
    productId = $(@).data('product-id')
    if Huali.Cart.get(productId).quantity is 0
      Huali.Cart.update(id: productId, quantity: 1)

      table = if $('.suggestion-on-current').length is 0 then '.side-table' else '.item-table'

      appendToTable(table, $(@).data('field-for-table'))
      updateTable(table)

    return false

# ported from https://github.com/segmentio/is-meta
window.isMeta = (e) ->
  if (e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)
    return true

  # Logic that handles checks for the middle mouse button, based
  # on [jQuery](https://github.com/jquery/jquery/blob/master/src/event.js#L466).
  which = e.which; button = e.button

  if (!which && button != undefined)
    return (!button & 1) && (!button & 2) && (button & 4);
  else if (which == 2)
    return true

  return false

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

      $(this).attr('href', href + region)
    else
      event.preventDefault()
