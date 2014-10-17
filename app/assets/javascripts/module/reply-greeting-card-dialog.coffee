
$ ->
  getParams = ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)
    params

  
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = (height/2) - ($('#reply-greeting-card-dialog-box').height()/2)
    dialogLeft = (width/2) - ($('#reply-greeting-card-dialog-box').width()/2)
    $("#reply-greeting-card-dialog-overlay").css({height: docHeight, width: width}).show()
    $("#reply-greeting-card-dialog-box").css({top: dialogTop, left: dialogLeft}).show()

  $('#reply-greeting-card-dialog-overlay').click ->
    $('#reply-greeting-card-dialog-overlay, #reply-greeting-card-dialog-box').hide()
    return false

  $('.close-dialog').click ->
    $('#reply-greeting-card-dialog-overlay, #reply-greeting-card-dialog-box').hide()
    return false

  $('#reply-greeting-card-dialog').click ->
    popup()
    return false

  if getParams().uuid?
    popup()
    return false

  $("#reply-greeting-card-btn").click ->

    phone =  $("#appointment_customer_phone").val()
    email =  $("#appointment_customer_email").val()
    if phone == "" && email == ""
      $(".dialog-message").append("<p style=\"color: red; text-align: center;\">至少需要填写一种联系方式哦<p>")
      return false

  $(window).resize ->
    if !$("#reply-greeting-card-dialog-box").is(":hidden")
      popup()

