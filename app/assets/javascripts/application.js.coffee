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
#= require orders
#= require jquery_ujs
#= require jquery.ui.effect
#= require underscore
#= require_self

$ ->
  $('.desktop .nav a').hover(arrowIn, arrowOut)

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

  # weibo sharing
  content = "感情若只低诉，整个世界都将失语。在这个冬日，用明信片来传递一直没能表达的感情。 我从@花里花店 ，免费寄出了一张明信片。你也快来吧~"
  url = document.location.href.replace('share', 'products')

  $('#post-share').attr 'href', weiboUrl(content, url)

  # nav accordion
  allPanels = $('.accordion > dd')

  $('.accordion > dt > a').click ->
    handler = $(@)
    allPanels.slideUp()

    if handler.hasClass('opened')
      handler
        .removeClass('opened')
    else
      handler
        .parent().next().slideDown()
        .end().end()
        .addClass('opened')

    allPanels
      .prev().find('a')
      .removeClass('opened')

    false

arrowIn = ->
  $(this).siblings('.arrow')
    .addClass('near', 100)
    .addClass('visible')

arrowOut = ->
  $(this).siblings('.arrow')
    .removeClass('near', 100)
    .removeClass('visible')

# TODO use QueryString to refactor this

weiboUrl = (content, url)->
  root = 'http://service.weibo.com/share/share.php?'
  root +
    'title=' + content +
    '&' +
    'url=' + url +
    '&' +
    # 'pic=' + 'http://hua.li/assets/share-img.jpg'
    'pic=' + 'http://www.hua.li/system/assets/images/000/000/139/medium/DSC_2509_copy.jpg'
