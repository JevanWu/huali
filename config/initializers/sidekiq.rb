# Custom Redis configuration
resque_url = "#{ENV['REDIS_HOST']}:6379"

Sidekiq.configure_server do |config|
  config.failures_default_mode = :exhausted
  config.redis = { url: "redis://#{resque_url}" }
  config.error_handlers << Proc.new { |ex, ctx_hash| Squash::Ruby.notify(ex, ctx_hash) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{resque_url}" }
end
