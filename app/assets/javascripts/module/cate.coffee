$ ->
  #cate.html tab切换
  $(".tabs a").each (i,el) ->
    $(this).click ->
      tabIndex = $(this).index() - 1
      $("ul.row-item,.best-products").addClass("is-hidden").eq(tabIndex).removeClass("is-hidden")
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
