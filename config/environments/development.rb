Huali::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ActionMailer Config for development, error raised
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # only use zh-CN locale in development
  config.i18n.locale = :"zh-CN"

  # Paperclip path
  Paperclip.options[:command_path] = "/usr/local/bin/"

  Highcharts::Converter.options[:command_path] = "/usr/local/bin/"

  # Custome configurations
  # Log sms to file(Rails.root/tmp/sms/) instead really sending it
  config.sms_delivery_method = :file
end
