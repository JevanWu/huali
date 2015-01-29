$ ->
  [proSelector, citySelector, areaSelector] = $('select').filter (index) ->
    $(@).attr('id').match /_address_\w+$/

  updateProvinceSelector = ->
    $.ajax
      url: "/provinces"
      dataType: 'json'
      success: (data) -> $(proSelector).empty().append reduceToOptions(data)

  updateCitySelector = (prov_id) ->
    return unless prov_id?.length > 0
    $.ajax
      url: "/provinces/#{prov_id}/cities"
      dataType: 'json'
      success: (data) -> $(citySelector).empty().append reduceToOptions(data)

  updateAreaSelector = (city_id) ->
    return unless city_id?.length > 0
    $.ajax
      url: "/cities/#{city_id}/areas"
      dataType: 'json'
      success: (data) -> $(areaSelector).empty().append reduceToOptions(data)

  emptyAreaSelector = ->
    $(areaSelector).empty()

  reduceToOptions = (data) ->
    _.reduce(data, (memo, place) ->
      memo + "<option value=#{place.id} data-postcode='#{place.post_code}'>#{place.name}</option>"
    , '<option value>请选择</option>')

  $(proSelector).on 'change',  ->
    emptyAreaSelector()
    updateCitySelector $(@).val()

  $(citySelector).on 'change', ->
    updateAreaSelector $(@).val()