# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require jquery.iosslider

$ ->
  $('.iosSlider').iosSlider({
    desktopClickDrag   : true
    touchMoveThreshold : 4
    snapToChildren     : true
    infiniteSlider     : true
    autoSlide          : false
    autoSlideTimer     : 5000
    navSlideSelector   : '.sliderNavi .naviItem'
    navNextSelector    : '.iosSlider .next'
    navPrevSelector    : '.iosSlider .prev'
    onSlideChange      : slideContentChange
    onSlideComplete    : slideContentComplete
    onSliderLoaded     : slideContentLoaded
  });

slideContentChange = (args) ->
  $(args.sliderObject).parent().find(".iosSliderButtons .button").removeClass "selected"
  $(args.sliderObject).parent().find(".iosSliderButtons .button:eq(" + args.currentSlideNumber + ")").addClass "selected"
  $(".sliderNavi .naviItem").removeClass "selected"
  $(".sliderNavi .naviItem:eq(" + args.currentSlideNumber + ")").addClass "selected"

slideContentComplete = (args) ->
  $(args.sliderObject).find(".text1, .text2").attr "style", ""
  $(args.currentSlideObject).children(".text1").animate
    left: "50px"
    opacity: "1"
  , 400, "easeOutQuint"
  $(args.currentSlideObject).children(".text2").delay(200).animate
    right: "70px"
    opacity: "1"
  , 400, "easeOutQuint"

slideContentLoaded = (args) ->
  $(args.sliderObject).find(".text1, .text2").attr "style", ""
  $(args.currentSlideObject).children(".text1").animate
    left: "50px"
    opacity: "1"
  , 400, "easeOutQuint"
  $(args.currentSlideObject).children(".text2").delay(200).animate
    right: "70px"
    opacity: "1"
  , 400, "easeOutQuint"
  $(args.sliderObject).parent().find(".iosSliderButtons .button").removeClass "selected"
  $(args.sliderObject).parent().find(".iosSliderButtons .button:eq(" + args.currentSlideNumber + ")").addClass "selected"
