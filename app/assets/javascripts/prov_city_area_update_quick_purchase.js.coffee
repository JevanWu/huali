$ ->
  [proSelector, citySelector, areaSelector] = $('select').filter (index) ->
    $(@).attr('id').match /_address_(province|city|area)_id$/

  updateCitySelector = (prov_id, default_value) ->
    return unless prov_id?.length > 0
    $.ajax
      url: "/provinces/#{prov_id}/cities"
      dataType: 'json'
      success: (data) ->
        $(citySelector).empty().append(reduceToOptions(data))
        toggleSelector(citySelector, false)
        selectValue(citySelector, default_value) if default_value?
      beforeSend: ->
        toggleSelector(citySelector, true)

  updateAreaSelector = (city_id, default_value) ->
    return unless city_id?.length > 0
    $.ajax
      url: "/cities/#{city_id}/areas"
      dataType: 'json'
      success: (data) ->
        $(areaSelector).empty().append(reduceToOptions(data))
        toggleSelector(areaSelector, false)
        selectValue(areaSelector, default_value) if default_value?
      beforeSend: ->
        toggleSelector(areaSelector, true)

  selectValue = (selector, value) ->
    $(selector).val(value).trigger("chosen:updated").trigger('change')

  toggleSelector = (selector, disabled) ->
    $(selector).prop('disabled', disabled).trigger("chosen:updated")
    $(selector).siblings().last().toggle(disabled)

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
    updateCitySelector $(@).val(), $.cookie('address_city_id')

  $(citySelector).on 'change', ->
    updateAreaSelector $(@).val(), $.cookie('address_area_id')

  updateProvinceSelector($.cookie('address_province_id'))
