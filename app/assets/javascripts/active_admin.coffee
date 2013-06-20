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
  $provinceIds = $("#region_rule_province_ids")
  $cityIds = $("#region_rule_city_ids")
  $areaIds = $("#region_rule_area_ids")

  # Set ids to memory
  window.RegionRule = {}
  RegionRule.provinceIds = $provinceIds.val().split(',')
  RegionRule.cityIds = $cityIds.val().split(',')
  RegionRule.areaIds = $areaIds.val().split(',')

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
    $cityForms = $(".city[pid='" + pid + "']")

    cityIdsOfProvince = ($cityForms.map ->
      $(@).attr("cid")).get()

    if @checked
      # Add the province_id to RegionRule.provinceIds
      RegionRule.provinceIds.push(pid)
      RegionRule.provinceIds = $.unique(RegionRule.provinceIds)

      # Add cities of the province to RegionRule.cityIds and then check the city checkboxes of the province
      RegionRule.cityIds = RegionRule.cityIds.concat(cityIdsOfProvince)
      RegionRule.cityIds = $.unique(RegionRule.cityIds)
      $cityForms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the province_id from RegionRule.provinceIds
      index = RegionRule.provinceIds.indexOf(pid)
      RegionRule.provinceIds.splice(index, 1)

      # Remove cities of the province from RegionRule.cityIds and then uncheck the city checkboxes
      $.each cityIdsOfProvince, (i, v) ->
        c_index = RegionRule.cityIds.indexOf(v)
        if c_index != -1
          RegionRule.cityIds.splice(c_index, 1)

      $cityForms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[cid]").change ->
    cid = $(@).attr("cid")
    $areaForms = $(".area[cid='" + cid + "']")

    areaIdsOfCity = ($areaForms.map ->
      $(@).attr("aid")).get()

    if @checked
      # Add the city_id to RegionRule.cityIds
      RegionRule.cityIds.push(cid)
      RegionRule.cityIds = $.unique(RegionRule.cityIds)

      # Add areas of the city to RegionRule.areaIds and then check the area checkboxes of the city
      RegionRule.areaIds = RegionRule.areaIds.concat(areaIdsOfCity)
      RegionRule.areaIds = $.unique(RegionRule.areaIds)
      $areaForms.prev().find("input:checkbox").prop("checked", true)
    else
      # Remove the city_id from city_ids
      index = RegionRule.cityIds.indexOf(cid)
      RegionRule.cityIds.splice(index, 1)

      # Remove areas of the city from RegionRule.areaIds and then uncheck the area checkboxes
      $.each areaIdsOfCity, (i, v) ->
        a_index = RegionRule.areaIds.indexOf(v)
        if a_index != -1
          RegionRule.areaIds.splice(a_index, 1)

      $areaForms.prev().find("input:checkbox").prop("checked", false)

  $("input:checkbox[aid]").change ->
    aid = $(@).attr("aid")

    if @checked
      # Add the area_id to area_ids
      RegionRule.areaIds.push(aid)
      RegionRule.areaIds = $.unique(RegionRule.areaIds)
    else
      # Remove the area_id from area_ids
      index = RegionRule.areaIds.indexOf(aid)
      RegionRule.areaIds.splice(index, 1)

  $("#save_region_rule").click (event)->
    $provinceIds.val(RegionRule.provinceIds.join(','))
    $cityIds.val(RegionRule.cityIds.join(','))
    $areaIds.val(RegionRule.areaIds.join(','))
    event.preventDefault()
