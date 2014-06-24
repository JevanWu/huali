function remove_fields(link){
  $(link).prev("input[type=hidden]").val(1);
  $(link).closest(".fields").hide();
}

function add_fields(link, field){
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_field", "g")
  $(link).before(field.replace(regexp, new_id));
}
