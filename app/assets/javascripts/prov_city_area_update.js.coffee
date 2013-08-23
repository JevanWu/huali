$ ->
  [proSelector, citySelector, areaSelector] = $('select').filter (index) ->
    $(@).attr('id').match /address_attributes_(province|city|area)/

  updateProvinceSelector = ->
    $.ajax
      url: "/provinces/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) -> $(proSelector).empty().append reduceToOptions(data)

  updateCitySelector = (prov_id) ->
    return unless prov_id?.length > 0
    $.ajax
      url: "/provinces/#{prov_id}/cities/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) -> $(citySelector).empty().append reduceToOptions(data)

  updateAreaSelector = (city_id) ->
    return unless city_id?.length > 0
    $.ajax
      url: "/cities/#{city_id}/areas/available_for_products"
      dataType: 'json'
      data: { product_ids: Cart.product_ids().join(',') }
      success: (data) -> $(areaSelector).empty().append reduceToOptions(data)

  emptyAreaSelector = ->
    $(areaSelector).empty()

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
