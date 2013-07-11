# set FileStore in /tmp/miniprofiler
if Rails.env == 'development' && defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::FileStore
end
