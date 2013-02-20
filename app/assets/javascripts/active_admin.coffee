#= require active_admin/base
#= require jquery.barcode.0.3

$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp $(this).data('id'), 'g'
    $(this).parent().before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.barcode35').barcode(code: 'code39')

  $('.print').click -> window.print()
