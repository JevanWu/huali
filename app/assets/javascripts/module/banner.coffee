$ ->
  bannerTemplate = """
  <div id="banner">
    <p>
      <%- content %>
    </p>
  </div>
  """

  fetchNewBanner = (banners) ->
    _.find banners, (banner) ->
      ! _.contains(bannersReaded(), banner.id)

  bannersReaded = ->
    $.cookie('bannersReaded') || []

  updateBannersReaded = (bannerJustReaded) ->
    $.cookie('bannersReaded', bannersReaded().concat(bannerJustReaded),
      expires: 365, path: '/')

  renderBanner = (banner) ->
    bannerHtml = _.template(bannerTemplate, banner)
    $(".notification-banner").append(bannerHtml)

  $.ajax
    url: "/banners/#{moment().format('YYYY-MM-DD')}"
    dataType: 'json'
    success: (banners) ->
      if newBanner = fetchNewBanner(banners)
        renderBanner(newBanner)
