$ ->
  showLoadingGif = ->
    $('.loading-gif').fadeTo(200,1)

  hideLoadingGif = ->
    $('.loading-gif').fadeTo(200,0)

  ajaxPool = []
  ajaxPool.abortAll = ->
    $(@).each( (idx, jqXHR) ->
      jqXHR.abort())
    ajaxPool.length = 0

  chkUserExist = (email) ->
    showLoadingGif()
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
          $('input#user_email').val(result.email)
          $('form.sign-up-oauth').removeClass('user-not-exist').addClass('user-exist')
          hideLoadingGif()
        else
          $('form.sign-up-oauth').removeClass('user-exist').addClass('user-not-exist')

  $('form.sign-up-oauth input#user_email').on('keypress paste textInput input', ->
    chkUserExist $(@).val()
  ).on('blur', ->
    hideLoadingGif()
  ).each( ->
    chkUserExist $(@).val()
  )

  chkUserExist( $('form.sign-up-oauth input#user_email').val() )