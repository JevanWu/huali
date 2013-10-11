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

class Cookie
  constructor: ->
    @constructor = "Cookie"
    return

  @setCookie: (name, value, expires) ->
    expiresDate = new Date().getDate() + expires
    document.cookie = name + "=" + value + ";expires=" + expiresDate
    return

  @getCookie: (name) ->
    arr = document.cookie.split(";")
    for coo,i in arr
      arr2=arr[i].split("=")
      if arr2[0] is name then return aa2[i]
    ""
  @removeCookie: (name) ->
    setCookie(name, "", -1)
    return

class component
  constructor: ->
    return


Huali.Event = Event
Huali.Cookie = Cookie

Huali.component = component

window.Huali = Huali
