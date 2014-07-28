#= require active_admin/base
#= require jquery.barcode.0.3
#= require jquery.tagsinput
#= require region_rule_edit
#= require admin_prov_city_area_update
#= require chosen-jquery
#= require highcharts
#= require highcharts/modules/exporting

$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    if (!confirm('Are you sure?'))
      return false

    $(this).parent().parent().find('input[id$="_destroy"]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.remove_form_object_attr', (event) ->
    if (!confirm('Are you sure?'))
      return false

    quantityField = $(this).parent().prev()
    productField = $(this).parent().prev().prev()
    blankSpace = $(this).parent().next()

    $(this).parent().remove()
    quantityField.remove()
    productField.remove()
    blankSpace.remove()

    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp $(this).data('id'), 'g'
    $(this).parent().before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

    $('.chosen').chosen({width: "30%"})

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

  $('.chosen').chosen({width: "30%"})
  $('.chosen-allow-deselect').chosen({width: "30%", allow_single_deselect: true})
  $('.chosen-small').chosen({width: "100px"})

$ ->
  done = '<div class="flashes"><div class="flash flash_notice">更新成功</div></div>'
  fail = '<div class="flashes"><div class="flash flash_error">更新失败，请刷新后重试</div></div>'

  ActiveAdminSortableEvent.add 'ajaxDone', ->
    unless $('.flash_notice').length > 0
      $('.flashes').remove()
      $('#title_bar').after(done)

  ActiveAdminSortableEvent.add 'ajaxFail', ->
    unless $('.flash_error').length > 0
      $('.flashes').remove()
      $('#title_bar').after(fail)

$ ->
  $("#trait_tags .tag").click ->
    tag = $(this).attr('value')
    unless $('#product_trait_list').tagExist(tag)
      $('#product_trait_list').addTag(tag)
    return false
