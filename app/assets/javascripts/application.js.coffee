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
#= require jquery.ui.effect-slide
#= require jquery.hoverIntent.minified
#= require underscore
#= require_self

$ ->
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
  content = "见字如面，爱时须言。我在@花里花店 免费寄出了一张明信片。你也来看看吧~"
  url = 'http://s.zenhacks.org/adec943'

  $('#post-share').attr 'href', weiboUrl(content, url)

  # nav-panel
  $('.nav-panel > dt')
    .mouseenter(headingMouseEnter)
    .mouseleave(headingMouseLeave)
    .hoverIntent({
      out: headingMouseLeaveIntent,
      timeout: 400
      })

  $('#nav-flyout')
    .mouseenter(flyoutMouseEnter)
    .mouseleave(flyoutMouseLeave)
    .hoverIntent({
      out: flyoutMouseLeaveIntent,
      timeout: 400
      })

  return false

allHeadings = $('.nav-panel > dt')
flyoutShowed = false
mouseInHeadings = false
mouseInFlyout = false

refreshOpenedClass = (x) ->
  if x
    allHeadings.not(x).switchClass('opened','')
    x.addClass('opened')
  else
    allHeadings.switchClass('opened','')

changeFlyout = (x) ->
  $('#nav-flyout').html(x.next().html())
  pos = x.position();
  $("#nav-flyout").css({
      top: (pos.top + 25) + "px",
      left: (pos.left + 10) + "px"
  });
  $('#nav-flyout li a').hover(arrowIn, arrowOut)
  # must add event listener again, because of the changing of html content

showFlyout = ->
  flyoutShowed = true
  $('#nav-flyout').stop().show("slide","fast").css('opacity',1)

hideFlyout = ->
  flyoutShowed = false
  $('#nav-flyout').stop().fadeOut()

headingMouseEnter = ->
  mouseInHeadings = true
  handler = $(@)
  if flyoutShowed
    if not handler.hasClass('opened')
      refreshOpenedClass(handler)
      changeFlyout(handler)
  else
    refreshOpenedClass(handler)
    changeFlyout(handler)
    showFlyout()

headingMouseLeave = ->
    mouseInHeadings = false

headingMouseLeaveIntent = ->
  if not mouseInFlyout and not mouseInHeadings
    hideFlyout()
    refreshOpenedClass()
    flyoutShowed = false

flyoutMouseEnter = ->
  mouseInFlyout = true

flyoutMouseLeave = ->
  mouseInFlyout = false

flyoutMouseLeaveIntent = ->
  if not mouseInFlyout and not mouseInHeadings
    hideFlyout()
    refreshOpenedClass()
    flyoutShowed = false

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