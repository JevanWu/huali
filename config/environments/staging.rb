Huali::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Enable the asset pipeline
  config.assets.enabled = true

  # Version of your assets, change this if you want to expire all your assets
  config.assets.version = '1.1'

  # Compress JavaScripts and CSS
  config.assets.css_compressor = :sass
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( application.js application-mobile.js admin_shipment_print.css email.css mobile.css pc.css ie7.css ie8.css active_admin_print.css modules/qrcode.css jquery.ui.datepicker.css home.js collections.js products.js pages.js ga.js html5shiv.js datepicker-settings.js jquery.imagesloaded.js weibo-stories.js)
  config.assets.precompile += %w( oauth.js segmentio.js admin_order_print.css admin_order_print.js admin_card_print.css admin_card_print.js bootstrap-slider.js bootstrap-slider.css prov_city_area_update.js json3.js active_admin/sortable.js active_admin/sortable.css modules/appointment-dialog.css)
  config.assets.precompile += %w( *.png *.jpg *.jpeg *.gif *.ico )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Setup for production - deliveries, no errors raised
  config.action_mailer.default_url_options = { host: 'staging.hua.li' }
  config.action_mailer.raise_delivery_errors = false
  # Log mail instead of really sending it
  config.action_mailer.delivery_method = :file


  # ImageMagick Process path on production server (Ubuntu 12.04 LTS)
  Paperclip.options[:command_path] = "/usr/bin/"

  Highcharts::Converter.options[:command_path] = "/usr/bin/"

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Log sms to file(Rails.root/tmp/sms/) instead really sending it
  config.sms_delivery_method = :file
end
