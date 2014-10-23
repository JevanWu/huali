$ ->
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = 250
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

  $("#reply-greeting-card-btn").click ->
    if $("#reply_greeting_card_response").val() == ""
      $(".dialog-message").append("<p style=\"color: red; text-align: center;\">请填写撒娇语<p>")
      return false

  $(window).resize ->
    if !$("#reply-greeting-card-dialog-box").is(":hidden")
      popup()

  getParams = ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)
    params

  if getParams().uuid?
    popup()
    return false

