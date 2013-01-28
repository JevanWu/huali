$ ->
  [proSelector, citySelector, areaSelector] = $('select').filter (index) ->
    $(@).attr('id').match /address_attributes/

  updateCitySelector = (prov_id) ->
    $.ajax
      url: "/provinces/#{prov_id}/cities"
      dataType: 'json'
      success: (data) -> $(citySelector).empty().append reduceToOptions(data)

  updateAreaSelector = (city_id) ->
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

  # refresh the city lists on ready
  updateCitySelector $(proSelector).val() if proSelector

  $(proSelector).on 'change',  ->
    emptyAreaSelector()
    updateCitySelector $(@).val()

  $(citySelector).on 'change', ->
    updateAreaSelector $(@).val()

