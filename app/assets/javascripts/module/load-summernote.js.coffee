# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.loadSummernote = ->
  # to set summernote object
  # You should change '#post_content' to your textarea input id
  summerNote = $(".summernote")

  # to call summernote editor
  summerNote.summernote
    # to set options
    height:300
    #lang: 'ko-KR'
    toolbar: [
                ["style", ["style"]],
                ["fontsize", ["fontsize"]],
                ["color", ["color"]],
                ["style", ["bold", "italic", "underline", "clear"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["height", ["height"]],
                ["table", ["table"]],
                ["help", ["help"]]
             ]

  # to set code for summernote
  summerNote.code summerNote.val()

  # to get code for summernote
  summerNote.closest('form').submit ->
    summerNote.val summerNote.code()
    true

$(document).ready  ->
  $(loadSummernote)
