# set FileStore in /tmp/miniprofiler
if Rails.env == 'development'
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::FileStore
end
