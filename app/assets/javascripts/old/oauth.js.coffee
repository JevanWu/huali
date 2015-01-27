$ ->
  showLoading = ->
    $('.loading').fadeTo(200, 1)

  hideLoading = ->
    $('.loading').fadeTo(200, 0)

  toggleFormInputs = (userExist) ->
    if userExist
      $('#user-exist').show()
      $('#user-not-exist').hide()
    else
      $('#user-exist').hide()
      $('#user-not-exist').show()

  ajaxPool = []
  ajaxPool.abortAll = ->
    $(@).each (idx, jqXHR) ->
      jqXHR.abort()

    ajaxPool.length = 0

  checkEmailExistence = (email) ->
    return unless !! email

    $.ajax
      url: "/users/check_user_exist"
      cache: false
      dataType: 'json'
      data: { user_email: email }
      beforeSend: (jqXHR) ->
        ajaxPool.abortAll()
        ajaxPool.push jqXHR
        showLoading()
      success: (result) ->
        hideLoading()
        toggleFormInputs(result.found)

  $('form.sign-up-oauth input#user_email').on('keypress paste textInput input', ->
    checkEmailExistence $(@).val()
  ).on('blur', ->
    hideLoading()
  ).each( ->
    checkEmailExistence $(@).val()
  )

  checkEmailExistence $('form.sign-up-oauth input#user_email').val()
