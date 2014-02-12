#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN

$ ->
  $('.datepicker').datepicker(
      gotoCurrent: true
      # shift order acceptance date after 17:00 every day
      minDate: if (new Date().getHours() >= 17) then '+2D' else '+1D'
      maxDate: '+2Y'
  )

  $('.datepicker-full').datepicker(
      gotoCurrent: true
      minDate: '+1D'
  )
