$ ->
  banner_template = """
  <div id="banner">
    <p><%- content %></p>
    <a class="close" href="#" data-banner="<%- id %>"></a>
  </div>
  """

  fetch_new_banner = (banners) ->
    _.find banners, (banner) ->
      ! _.contains(banners_readed(), banner.id)

  banners_readed = ->
    $.cookie('banners_readed') || []

  update_banners_readed = (banner_just_readed) ->
    $.cookie('banners_readed', banners_readed().concat(banner_just_readed),
      expires: 365, path: '/')

  render_banner = (banner) ->
    banner_html = _.template(banner_template, banner)
    $(".notification-banner").append(banner_html)

  $.ajax
    url: "/banners/#{moment().format('YYYY-MM-DD')}"
    dataType: 'json'
    success: (banners) ->
      if new_banner = fetch_new_banner(banners)
        render_banner(new_banner)
  $(document).on "click", "#banner .close", (event) ->
    update_banners_readed($(this).data('banner'))
    $('#banner').remove()
    event.preventDefault()
