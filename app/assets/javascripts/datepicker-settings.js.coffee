#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN

$ ->
  $('.datepicker').datepicker(
      gotoCurrent: true
      minDate: '+2D'
      maxDate: '+1M'
  )

  $('.datepicker-full').datepicker(
      gotoCurrent: true
      minDate: '+1D'
  )
