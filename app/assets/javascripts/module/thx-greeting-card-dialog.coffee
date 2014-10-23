$ ->
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = 250
    dialogLeft = (width/2) - ($('#thx-greeting-card-dialog-box').width()/2)
    $("#thx-greeting-card-dialog-overlay").css({height: docHeight, width: width}).show()
    $("#thx-greeting-card-dialog-box").css({top: dialogTop, left: dialogLeft}).show()

  $('#thx-greeting-card-dialog-overlay').click ->
    $('#thx-greeting-card-dialog-overlay, #thx-greeting-card-dialog-box').hide()
    return false

  $('.close-dialog').click ->
    $('#thx-greeting-card-dialog-overlay, #thx-greeting-card-dialog-box').hide()
    return false

  $('#thx-greeting-card-dialog').click ->
    popup()
    return false

  $("#thx-greeting-card-btn").click ->
    if $("#thx_greeting_card_response").val() == ""
      $(".dialog-message").append("<p style=\"color: red; text-align: center;\">请填写答谢语<p>")
      return false

  $(window).resize ->
    if !$("#thx-greeting-card-dialog-box").is(":hidden")
      popup()

  getParams = ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)
    params

  if getParams().uid?
    popup()
    return false
  

