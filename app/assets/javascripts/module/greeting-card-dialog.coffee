$ ->
  popup = ->
    height = $(window).height()
    docHeight = $(document).height()
    width = $(window).width()
    dialogTop = (height/1.5) - ($('#greeting-card-dialog-box').height()/1.5)
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

    phone =  $("#appointment_customer_phone").val()
    email =  $("#appointment_customer_email").val()
    if phone == "" && email == ""
      $(".dialog-message").append("<p style=\"color: red; text-align: center;\">至少需要填写一种联系方式哦<p>")
      return false

  $(window).resize ->
    if !$("#greeting-card-dialog-box").is(":hidden")
      popup()

