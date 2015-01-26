$(document).ready ->
  
  # Update the text of the submit button to let the user know stuff is happening.
  # But first, store the original text of the submit button, so it can be restored when the request is finished.
  
  # Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
  
  # Insert response partial into page below the form.
  
  # Restore the original submit button text
  $("#quick_purchase_form").bind("ajax:beforeSend", (evt, xhr, settings) ->
    $submitButton = $(this).find("input[name=\"commit\"]")
    $submitButton.data "origText", $(this).text()
    $submitButton.text "Submitting..."
    return
  ).bind("ajax:success", (evt, data, status, xhr) ->
    $form = $(this)
    $form.find("textarea,input[type=\"text\"],input[type=\"file\"]").val ""
    $form.find("div.validation-error").empty()
    $(".mains").replaceWith hr.responseText
    return
  ).bind("ajax:complete", (evt, xhr, status) ->
    $submitButton = $(this).find("input[name=\"commit\"]")
    $submitButton.text $(this).data("origText")
    return
  ).bind "ajax:error", (evt, xhr, status, error) ->
    $form = $(this)
    errors = undefined
    errorText = undefined
    try
      
      # Populate errorText with the comment errors
      errors = $.parseJSON(xhr.responseText)
    catch err
      
      # If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
      errors = message: "Please reload the page and try again"
    
    # Build an unordered list from the list of errors
    errorText = "There were errors with the submission: \n<ul>"
    for error of errors
      errorText += "<li>" + error + ": " + errors[error] + "</li> "
    errorText += "</ul>"
    
    # Insert error list into form
    $form.find("div.validation-error").html errorText
    return

  return
