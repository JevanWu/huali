#= require jquery
#= require underscore
#= require bootstrap
#= require bootstrap-slider
$ ->
  # content initialize and updates
  $content = $("#content")
  $body = $('#body div')
  $receiver = $('#receiver')
  $sender = $('#sender')
  content = $body.text().trim()
  $('#body-input').val(content)
  $('p', $content).css 'font-family', $('#font-family-input').val()

  $("#receiver-input").on 'change', ->
    $receiver.html preserveText $(@).val()

  $("#sender-input").on 'change', ->
    $sender.html preserveText $(@).val()

  $('#body-input').on 'change', ->
    $body.html preserveText $(@).val()

  $('#font-family-input').on 'change', ->
    fontFamily = $(@).val()
    $('p', $content).css('font-family', "#{fontFamily}")

  $('#line-height').slider
    min: 15
    max: 50
    step: 1
  .on 'slideStop', (e) ->
    lineHeight = $(@).val()
    $('p', $content).css('line-height', "#{lineHeight}pt")

  $('#font-size').slider
    min: 9
    max: 40
    step: 1
  .on 'slideStop', (e) ->
    fontSize = $(@).val()
    $('p', $content).css('font-size', "#{fontSize}pt")

preserveText = (text) ->
  reducer = (start, line) ->
    line = line.replace(/\s/ig, '&nbsp;') # preserve spaces
    line = '<p>' + line + '</p>' # preserve linebreaks
    start + line

  _.reduce text.split('\n'), reducer, ""
