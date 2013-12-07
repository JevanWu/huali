$ ->
  #cate.html tab切换
  $(".tabs a").each (i,el) ->
    $(this).click ->
      tabIndex = $(this).index() - 1
      $(".cate-list-style1,.cate-list-style2").addClass("is-hidden").eq(tabIndex).removeClass("is-hidden")
      $(".tabs a").removeClass("active")
      $(".cate-list-style1,.cate-list-style2").eq(tabIndex).find(".tabs a").eq(tabIndex).addClass("active")
      return
    return

  $(".cate-list-style2 li").each (i,el) ->
    $(el).hammer().on "tap", ->
      $(el).css("background-color","#6495ed")
      location.href = $(el).find("h3 a").attr("href")
      return
    return

  return

$ ->
  $("#tag_filter a").click ->
    url = window.location.pathname
    isTagged = /tagged_with/i.test(url)

    url = "#{url}/tagged_with" unless isTagged

    unTaggedUrl = Utils.dirname(url).replace("/tagged_with", "")

    tags_in_path = if isTagged then decodeURIComponent(Utils.basename(url)).split(',') else []

    tag_selected = $(this).hasClass("label-inverse")
    this_tag = $(this).data("tag")

    if tag_selected
      tags = _.without(tags_in_path, this_tag)
    else
      tags = tags_in_path.concat(this_tag)

    if tags.length == 0
      window.location = unTaggedUrl
    else if isTagged
      window.location = "#{Utils.dirname(url)}/#{tags.join(',')}"
    else
      window.location = "#{url}/#{tags.join(',')}"

    return false
