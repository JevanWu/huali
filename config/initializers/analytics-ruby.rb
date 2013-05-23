secret = Rails.env == 'production' ? ENV['SEGMENTIO_SECRET'] : ENV['SEGMENTIO_DEV_SECRET']
Analytics.init secret: secret
