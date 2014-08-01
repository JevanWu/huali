window.Postcard = []
window.Postcard.remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val(1)
  $(link).closest(".fields").hide()

window.Postcard.add_fields = (link, field) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_field", "g")
  $(link).before(field.replace(regexp, new_id))
