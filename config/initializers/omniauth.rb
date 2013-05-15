Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :weibo, ENV['WEIBO_OAUTH_KEY'], ENV['WEIBO_OAUTH_SECRET']
end