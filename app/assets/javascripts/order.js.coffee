#= require 'jquery'
#= require 'jquery-1.7.2.min'
#= require 'jquery.scrollTo'
#= require 'jquery.SuperSlide.2.1.1'
#= require 'jquery.cookie'
#= require 'inform'
#= require 'chosen-jquery'
#= require 'chosen-select'
#= require 'prov_city_area_update'
#= require 'underscore'
#= require 'datepicker-settings'

$ ->
  $("button#gift-card-info-trigger").click (event) ->
    event.preventDefault()
    text = $(@).text()
    if text == "添加贺卡内容"
      $(@).text("隐藏贺卡内容")
    else
      $(@).text("添加贺卡内容")
      
    $('#gift-card-info').toggle('slow')
