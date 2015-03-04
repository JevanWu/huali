#= require_self

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

      $(this).attr('href', href + region)
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
