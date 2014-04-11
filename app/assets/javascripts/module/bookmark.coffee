$ ->
  $('#bookmarkme').click ->
    if window.sidebar and window.sidebar.addPanel # Mozilla Firefox Bookmark
      window.sidebar.addPanel(document.title,window.location.href, '')
    else if window.external and ('AddFavorite' of window.external)  # IE Favorite
      window.external.AddFavorite(location.href, document.title)
    else if window.opera and window.print # Opera Hotlist
      this.title = document.title
      return true
    else # webkit - safari/chrome
      alert("请按 #{if navigator.userAgent.toLowerCase().indexOf('mac') != -1 then 'Command/Cmd' else 'CTRL'} + D 键来收藏花里")
