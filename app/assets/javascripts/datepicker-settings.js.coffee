#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN

$ ->
  $('.datepicker').datepicker(
      gotoCurrent: true
      # shift order acceptance date after 17:00 every day
      minDate: if (new Date().getHours() >= 17) then '+3D' else '+2D'
      maxDate: '+1M'
  )

  $('.datepicker-full').datepicker(
      gotoCurrent: true
      minDate: '+1D'
  )
