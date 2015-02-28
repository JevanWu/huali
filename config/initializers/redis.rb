$redis = Redis.new url: "redis://#{ENV['REDIS_HOST']}:6379/1", timeout: 0.7
