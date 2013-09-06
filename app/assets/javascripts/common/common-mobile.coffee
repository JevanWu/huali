$ ->
  $("a.nav").hammer().on("tap", (e) ->
      $("nav").slideToggle()
      return
    )
	  return