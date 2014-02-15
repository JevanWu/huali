#= require jquery.ui.datepicker
#= require jquery.ui.datepicker-zh-CN

$ ->
  normalDateShift = if (new Date().getHours() >= 17) then '+2D' else '+1D'

  $('.datepicker').datepicker(
      gotoCurrent: true
      # shift order acceptance date after 17:00 every day
      minDate: normalDateShift
      maxDate: '+2Y'
  )

  $('.datepicker-full').datepicker(
      gotoCurrent: true
      minDate: '+1D'
      maxDate: '+2Y'
  )

  specialDateShift = if $.inArray(new Date().getDate(), [15,16,17,18,19]) != -1 then '+5D' else normalDateShift
  $('.datepicker-special').datepicker(
      gotoCurrent: true
      minDate: specialDateShift
  )
