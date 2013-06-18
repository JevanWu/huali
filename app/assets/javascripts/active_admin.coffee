#= require active_admin/base
#= require jquery.barcode.0.3
#= require jquery.tagsinput

$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp $(this).data('id'), 'g'
    $(this).parent().before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.barcode35').barcode(code: 'code39')

  $('.print').click -> window.print()

  $('.tag-list').tagsInput
    height: '25px'
    width: '78%'
    defaultText:'添加新标签, 逗号分割'


# Product Region Rule Edit
$ ->
  $(".cities").dialog
    autoOpen: false
    height: 400
    width: 380
    modal: true
    buttons: { }
    close: ->
      # ...
  $(".areas").dialog
    autoOpen: false
    height: 400
    width: 380
    modal: true
    buttons: { }
    close: ->
      # ...

  $(".province").button().click (event)->
    pid = $(@).attr("pid")
    $("div[pid='" + pid + "']").dialog("open")
    event.preventDefault()

  $(".city").button().click (event)->
    cid = $(@).attr("cid")
    $("div[cid='" + cid + "']").dialog("open")
    event.preventDefault()

  $("input:checkbox[pid]").change ->
    $province_ids = $("#product_region_rule_attributes_province_ids")
    $city_ids = $("#product_region_rule_attributes_city_ids")

    province_ids = $province_ids.val().split(',')
    city_ids = $city_ids.val().split(',')

    pid = $(@).attr("pid")
    $city_forms = $(".city[pid='" + pid + "']")

    city_ids_of_province = ($city_forms.map ->
      $(@).attr("cid")).get()

    if @checked
      # Add the province_id to province_ids
      province_ids.push(pid)
      province_ids = $.unique(province_ids)
      $province_ids.val(province_ids.join(','))

      # Add cities of the province to city_ids and then check the city checkboxes of the province
      city_ids = city_ids.concat(city_ids_of_province)
      city_ids = $.unique(city_ids)
      $city_ids.val(city_ids.join(','))
      $city_forms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the province_id from province_ids
      index = province_ids.indexOf(pid)
      province_ids.splice(index, 1)
      $province_ids.val(province_ids.join(','))

      # Remove cities of the province from city_ids and then uncheck the city checkboxes
      $.each city_ids_of_province, (i, v) ->
        c_index = city_ids.indexOf(v)
        if c_index != -1
          city_ids.splice(c_index, 1)

      $city_ids.val(city_ids.join(','))
      $city_forms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[cid]").change ->
    $city_ids = $("#product_region_rule_attributes_city_ids")
    $area_ids = $("#product_region_rule_attributes_area_ids")

    city_ids = $city_ids.val().split(',')
    area_ids = $area_ids.val().split(',')

    cid = $(@).attr("cid")
    $area_forms = $(".area[cid='" + cid + "']")

    area_ids_of_city = ($area_forms.map ->
      $(@).attr("aid")).get()

    if @checked
      # Add the city_id to city_ids
      city_ids.push(cid)
      city_ids = $.unique(city_ids)
      $city_ids.val(city_ids.join(','))

      # Add areas of the city to area_ids and then check the area checkboxes of the city
      area_ids = area_ids.concat(area_ids_of_city)
      area_ids = $.unique(area_ids)
      $area_ids.val(area_ids.join(','))
      $area_forms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the city_id from city_ids
      index = city_ids.indexOf(cid)
      city_ids.splice(index, 1)
      $city_ids.val(city_ids.join(','))

      # Remove areas of the city from area_ids and then uncheck the area checkboxes
      $.each area_ids_of_city, (i, v) ->
        a_index = area_ids.indexOf(v)
        if a_index != -1
          area_ids.splice(a_index, 1)

      $area_ids.val(area_ids.join(','))
      $area_forms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[aid]").change ->
    $area_ids = $("#product_region_rule_attributes_area_ids")

    area_ids = $area_ids.val().split(',')
    aid = $(@).attr("aid")

    if @checked
      # Add the area_id to area_ids
      area_ids.push(aid)
      area_ids = $.unique(area_ids)
      $area_ids.val(area_ids.join(','))
    else
      # Remove the area_id from area_ids
      index = area_ids.indexOf(aid)
      area_ids.splice(index, 1)
      $area_ids.val(area_ids.join(','))
