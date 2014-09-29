$ ->
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = (height/2) - ($('#dialog-box').height()/2)
    dialogLeft = (width/2) - ($('#dialog-box').width()/2)
    $("#dialog-overlay").css({height: docHeight, width: width}).show()
    $("#dialog-box").css({top: dialogTop, left: dialogLeft}).show()

  $('#dialog-overlay').click ->
    $('#dialog-overlay, #dialog-box').hide()
    return false

  $('#popup-dialog').click ->
    popup()
    return false

  $("#appointment-btn").click ->

    phone =  $("#appointment_customer_phone").val()
    email =  $("#appointment_customer_email").val()
    if phone == "" && email == ""
      $(".dialog-message").append("<p style=\"color: red; text-align: center;\">至少需要填写一种联系方式哦<p>")
      return false

  $(window).resize ->
    if !$("#dialog-box").is(":hidden")
      popup()
