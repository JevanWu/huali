# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui/effect
#= require orders

$ ->
  $('.nav a').hover(arrowIn, arrowOut)

  $('#image-slides img')
  	.hover($(this).toggleClass('hover'))
  	.first().addClass('current')

  $('#image-slides a').click ->
    showcase = $('#image-showcase')
    cover = $('#image-cover')
    url = $(this).attr('href')
    cover.addClass('loading')
    $.ajax(
      url: url
      success: (data) =>
        $(this).parents('.links').find('img').removeClass('current')
        showcase.find('img').attr('src', url)
        cover.removeClass('loading')
        $(this).find('img').addClass('current')
    )
    return false

arrowIn = ->
  $(this).siblings('.arrow')
    .addClass('near', 100)
    .addClass('visible')

arrowOut = ->
  $(this).siblings('.arrow')
    .removeClass('near', 100)
    .removeClass('visible')
