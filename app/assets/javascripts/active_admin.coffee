#= require active_admin/base
#= require jquery.barcode.0.3
#= require jquery.tagsinput
#= require region_rule_edit
#= require admin_prov_city_area_update

$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    if (!confirm('Are you sure?'))
      return false

    $(this).parent().parent().find('input[id$="_destroy"]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp $(this).data('id'), 'g'
    $(this).parent().before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.barcode35').barcode(code: 'code39')

  $('.print').click -> window.print()

  $('.tag-list').tagsInput
    height: '25px'
    width: '78%'
    defaultText:'添加新标签, 逗号分割'

  $('form').on 'click', '.add_region_rule', (event) ->
    $(this).prev().find('input[id$="_destroy"]').val(false)
    $(this).prev().show()
    $(this).hide()
    event.preventDefault()

  $('form').on 'click', '.add_date_rule', (event) ->
    $(this).prev().find('input[id$="_destroy"]').val(false)
    $(this).prev().show()
    $(this).hide()
    event.preventDefault()
