# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require jquery.iosslider
#= require easyzoom

$ ->
  $('.more-views').iosSlider({
      desktopClickDrag: true
      snapToChildren: true
      infiniteSlider: false
      navNextSelector: '.more-views-arrow.next'
      navPrevSelector: '.more-views-arrow.prev'
  })

  $('.zoom-thumbnail').on 'click', (e) ->
    e.preventDefault()
    $(this).addClass('thumbnail-active')
    $('.main-image').html($(this).attr('data_url'))
    $('#zoom').easyZoom({
      parent: '.product-essential'
    })

  $('#zoom').easyZoom({
    parent: '.product-essential'
  })
