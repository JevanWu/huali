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
  $province_ids = $("#product_region_rule_attributes_province_ids")
  $city_ids = $("#product_region_rule_attributes_city_ids")
  $area_ids = $("#product_region_rule_attributes_area_ids")

  # Set ids to memory
  window.huali_province_ids = $province_ids.val().split(',')
  window.huali_city_ids = $city_ids.val().split(',')
  window.huali_area_ids = $area_ids.val().split(',')

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
    pid = $(@).attr("pid")
    $city_forms = $(".city[pid='" + pid + "']")

    city_ids_of_province = ($city_forms.map ->
      $(@).attr("cid")).get()

    if @checked
      # Add the province_id to window.huali_province_ids
      window.huali_province_ids.push(pid)
      window.huali_province_ids = $.unique(window.huali_province_ids)

      # Add cities of the province to window.huali_city_ids and then check the city checkboxes of the province
      window.huali_city_ids = window.huali_city_ids.concat(city_ids_of_province)
      window.huali_city_ids = $.unique(window.huali_city_ids)
      $city_forms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the province_id from window.huali_province_ids
      index = window.huali_province_ids.indexOf(pid)
      window.huali_province_ids.splice(index, 1)

      # Remove cities of the province from window.huali_city_ids and then uncheck the city checkboxes
      $.each city_ids_of_province, (i, v) ->
        c_index = window.huali_city_ids.indexOf(v)
        if c_index != -1
          window.huali_city_ids.splice(c_index, 1)

      $city_forms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[cid]").change ->
    cid = $(@).attr("cid")
    $area_forms = $(".area[cid='" + cid + "']")

    area_ids_of_city = ($area_forms.map ->
      $(@).attr("aid")).get()

    if @checked
      # Add the city_id to window.huali_city_ids
      window.huali_city_ids.push(cid)
      window.huali_city_ids = $.unique(window.huali_city_ids)

      # Add areas of the city to window.huali_area_ids and then check the area checkboxes of the city
      window.huali_area_ids = window.huali_area_ids.concat(area_ids_of_city)
      window.huali_area_ids = $.unique(window.huali_area_ids)
      $area_forms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the city_id from city_ids
      index = window.huali_city_ids.indexOf(cid)
      window.huali_city_ids.splice(index, 1)

      # Remove areas of the city from window.huali_area_ids and then uncheck the area checkboxes
      $.each area_ids_of_city, (i, v) ->
        a_index = window.huali_area_ids.indexOf(v)
        if a_index != -1
          window.huali_area_ids.splice(a_index, 1)

      $area_forms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[aid]").change ->
    aid = $(@).attr("aid")

    if @checked
      # Add the area_id to area_ids
      window.huali_area_ids.push(aid)
      window.huali_area_ids = $.unique(window.huali_area_ids)
    else
      # Remove the area_id from area_ids
      index = window.huali_area_ids.indexOf(aid)
      window.huali_area_ids.splice(index, 1)

  $("#save_region_rule").click (event)->
    $province_ids.val(window.huali_province_ids.join(','))
    $city_ids.val(window.huali_city_ids.join(','))
    $area_ids.val(window.huali_area_ids.join(','))
    event.preventDefault()
