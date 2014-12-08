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

  $('.close-dialog').click ->
    $('#dialog-overlay, #dialog-box').hide()
    return false

  $('#qrpop').click ->
    popup()
    return false

  $(window).resize ->
    if !$("#dialog-box").is(":hidden")
      popup()

