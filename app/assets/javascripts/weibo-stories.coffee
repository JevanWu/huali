# Local variables
templateString = """
<li>
  <a href="<%= origin_link %>" target="_blank" rel="nofollow">
    <img src="<%= picture_url %>" width="<%= width %>" height="<%= height %>" />
  </a>
  <hr />
  <div>
    <img src="<%= author_avatar_url %>" width="40" height="40" />
    <%= description %>
  </div>
</li>
"""

handler = null
page = 1
isLoading = false
apiURL = "stories"
options =
  autoResize: true # This will auto-update the layout when the browser window is resized.
  container: $("#tiles") # Optional, used for some extra CSS styling
  offset: 20 # Optional, the distance between grid items
  outerOffset: 0

# When scrolled all the way to the bottom, add more tiles.
onScroll = (event) ->

  # Only check when we're not still waiting for data.
  unless isLoading
    # Check if we're within 100 pixels of the bottom edge of the broser window.
    closeToBottom = ($(window).scrollTop() + $(window).height() > $(document).height() - 100)
    loadData()  if closeToBottom

# Refreshes the layout.
applyLayout = ->
  options.container.imagesLoaded ->
    # Create a new layout handler when images have loaded.
    $("#loaderCircle").hide()
    handler = $("#tiles li")
    handler.wookmark options

# Loads data from the API.
loadData = ->
  isLoading = true
  $("#loaderCircle").show()
  setTimeout(100)
  $.ajax
    url: apiURL
    dataType: "jsonp"
    data: # Page parameter to make sure we load new data
      page: page

    success: onLoadData


# Receives data from the API, creates HTML for images and updates the layout
onLoadData = (data) ->
  isLoading = false

  length = data.length
  # Increment page index for future calls.
  page++ if length > 0

  # Create HTML for the images.
  html = ""

  i = 0
  image = undefined
  while i < length
    image = data[i]
    html += _.template(templateString, image)
    i++

  # Add image HTML to the page.
  $("#tiles").append html

  # Apply layout.
  applyLayout()

# Capture scroll event.
$(document).bind "scroll", onScroll

# Load first data from the API.
loadData()
