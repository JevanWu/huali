$ ->
  showLoadingGif = ->
    $('.loading-gif').fadeIn().css('display','inline-block')

  hideLoadingGif = (forever = false) ->
    $('.loading-gif').fadeOut()
    if forever is true
      $('.loading-gif').css('visibility', 'hidden')

  chkUserExist = (email) ->
    # FIXME, should abort other ajax first
    $.ajax
      url: "/users/check_user_exist"
      cache: false
      dataType: 'json'
      data: ({ user_email: email })
      success: (result) -> 
        if result.found is true
          hideLoadingGif(true)
          $('.user-dont-exist').hide()
          $('.user-exist').fadeIn(200, ->
            $('input#user_email').prop('disabled', true).val(result.email)
            $('.user-exist input#user_name_via_oauth').val(result.name_via_oauth)
            $('.user-exist input#user_name').val(result.name))

  $('form.sign-up-oauth input#user_email').on('change keypress paste textInput input', ->
    showLoadingGif()
    chkUserExist $(@).val())
