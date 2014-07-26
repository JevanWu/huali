$ ->
  [proSelector, citySelector, areaSelector] = $('select').filter (index) ->
    $(@).attr('id').match /_address_(province|city|area)_id$/

  updateProvinceSelector = ->
    $.ajax
      url: "/provinces/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) ->
        $(proSelector).empty().append(reduceToOptions(data))
        $(proSelector).trigger("chosen:updated")

  updateCitySelector = (prov_id) ->
    return unless prov_id?.length > 0
    $.ajax
      url: "/provinces/#{prov_id}/cities/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) ->
        $(citySelector).empty().append(reduceToOptions(data))
        $(citySelector).trigger("chosen:updated")

  updateAreaSelector = (city_id) ->
    return unless city_id?.length > 0
    $.ajax
      url: "/cities/#{city_id}/areas/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) ->
        $(areaSelector).empty().append(reduceToOptions(data))
        $(areaSelector).trigger("chosen:updated")

  emptyAreaSelector = ->
    $(areaSelector).empty()
    $(areaSelector).trigger("chosen:updated")

  reduceToOptions = (data) ->
    _.reduce(data, (memo, place) ->
      memo + "<option value=#{place.id} data-postcode='#{place.post_code}'>#{place.name}</option>"
    , '<option value>请选择</option>')

  # refresh the city lists on ready
  updateCitySelector $(proSelector).val() if proSelector

  $(proSelector).on 'change',  ->
    emptyAreaSelector()
    updateCitySelector $(@).val()

  $(citySelector).on 'change', ->
    updateAreaSelector $(@).val()

  updateProvinceSelector()
