$ ->
  showLoadingGif = ->
    $('.loading-gif').fadeIn().css('display','inline-block')

  hideLoadingGif = ->
    $('.loading-gif').fadeOut()

  userExist = ->
    hideLoadingGif()
    $('.user-dont-exist').hide()
    $('.user-exist').fadeIn()
    $('input#user_email').val(result.email)

  userNotExist = ->
    $('.user-exist').hide()
    $('.user-dont-exist').fadeIn()

  ajaxPool = []
  ajaxPool.abortAll = ->
    $(@).each( (idx, jqXHR) ->
      jqXHR.abort())
    ajaxPool.length = 0

  chkUserExist = (email) ->
    # FIXME, should abort other ajax first
    $.ajax
      url: "/users/check_user_exist"
      cache: false
      dataType: 'json'
      data: ({ user_email: email })
      beforeSend: (jqXHR) ->
        ajaxPool.abortAll()
        ajaxPool.push jqXHR
      success: (result) -> 
        if result.found is true
          userExist()
        else
          userNotExist()

  $('form.sign-up-oauth input#user_email').on('keypress paste textInput input', ->
    showLoadingGif()
    chkUserExist $(@).val()
  ).on('blur', ->
    hideLoadingGif()
  ).each( ->
    chkUserExist $(@).val()
  )
