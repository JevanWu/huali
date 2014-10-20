$ ->
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = (height/2) - ($('#greeting-card-dialog-box').height()/2)
    dialogLeft = (width/2) - ($('#greeting-card-dialog-box').width()/2)
    $("#greeting-card-dialog-overlay").css({height: docHeight, width: width}).show()
    $("#greeting-card-dialog-box").css({top: dialogTop, left: dialogLeft}).show()

  $('#greeting-card-dialog-overlay').click ->
    $('#greeting-card-dialog-overlay, #greeting-card-dialog-box').hide()
    return false

  $('.close-dialog').click ->
    $('#greeting-card-dialog-overlay, #greeting-card-dialog-box').hide()
    return false

  $('#greeting-card-dialog').click ->
    popup()
    return false

  $("#greeting-card-btn").click ->

    sender_email_pattern = /^\w+@\w+\.[a-zA-Z]{2,6}$/
    recipient_email_pattern = /^\w+@\w+\.[a-zA-Z]{2,6}(\s*,\s*\w+@\w+\.[a-zA-Z]{2,6})*$/

    recipient_email = $("#greeting_card_recipient_email").val()
    sender_email = $("#greeting_card_sender_email").val()
    sentiments = $("#greeting_card_sentiments").val()

    unless recipient_email.match recipient_email_pattern
      $(".message").append("<p style=\"color: red; text-align: center;\">收件人邮箱格式错误，请重新填写。<p>")
      return false

    unless sender_email.match sender_email_pattern
      $(".message").append("<p style=\"color: red; text-align: center;\">发件人邮箱格式错误，请重新填写。<p>")
      return false

    if sentiments == ""
      $(".message").append("<p style=\"color: red; text-align: center;\">请填写祝福语<p>")
      return false

  $(window).resize ->
    if !$("#greeting-card-dialog-box").is(":hidden")
      popup()

