Analytics.init(secret: Rails.env == 'production' ? ENV['SEGMENTIO_SECRET'] : ENV['SEGMENTIO_DEV_SECRET'])
