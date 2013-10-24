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
    handler = $("#tiles li")
    handler.wookmark options

# Loads data from the API.
loadData = ->
  isLoading = true
  $("#loaderCircle").show()
  $.ajax
    url: apiURL
    dataType: "jsonp"
    data: # Page parameter to make sure we load new data
      page: page

    success: onLoadData


# Receives data from the API, creates HTML for images and updates the layout
onLoadData = (data) ->
  isLoading = false
  $("#loaderCircle").hide()

  # Increment page index for future calls.
  page++

  # Create HTML for the images.
  html = ""
  i = 0
  length = data.length
  image = undefined
  while i < length
    image = data[i]
    html += _.template(templateString, image)
    i++

  # Add image HTML to the page.
  $("#tiles").append html

  # Apply layout.
  applyLayout()

templateString = """
<li>
  <img src="<%= src %>" width="<%= width %>" height="<%= height %>" />
  <div><%= description %></div>
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


# Capture scroll event.
$(document).bind "scroll", onScroll

# Load first data from the API.
loadData()
