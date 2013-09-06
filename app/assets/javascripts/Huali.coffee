class Huali
  constructor: ->
    return

class Event
  constructor: ->
    @constructor = "Event"
    return

  @eventListners: ->
    {}

  @emit: (eventName) =>
    theArgs = Array.prototype.slice.call(arguments,arguments.callee.length)
    @eventListners[eventName].apply(this,theArgs);
    return

  @on: (eventName, fn) =>
    if typeof eventName isnt "string"
      throw TypeError("The custom event name must be a string!")
    this.eventListners[eventName] = fn
    return

  @off: (eventName) =>
    delete this.eventListners[eventName]
    return

class component
  constructor: ->
    return

Huali.Event = Event
Huali.component = component
window.Huali = Huali