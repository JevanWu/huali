#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN

$ ->
  $('.datepicker').datepicker(
      gotoCurrent: true
      # shift order acceptance date after 17:00 every day
      minDate: if (new Date().getHours() >= 17) then '+1D' else '+0D'
      maxDate: '+2M'
  )

  $('.datepicker-full').datepicker(
      gotoCurrent: true
      minDate: '+1D'
  )
