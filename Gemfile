source "http://ruby.taobao.org"
# source "http://bundler-api.herokuapp.com"
#source 'http://rubygems.org'

gem 'rails', '~> 4.0.5'
gem 'pg', '>= 0.14.1'
gem 'devise', '~> 3.2.0'
gem 'devise_invitable', '~> 1.3.0'
gem 'devise-i18n'
gem 'devise-async'
gem 'cancan', '~> 1.0'
gem 'rails-i18n'
gem 'redis-rails'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'ransack'
gem 'inherited_resources'
gem 'formtastic'
gem 'axlsx', '2.0.0'
gem 'paperclip', '~> 3.0'
gem 'simple_form'
gem 'kramdown', '~> 0.13'
gem 'friendly_id'
# backup, whenever probably should be isolated in a server setup script
gem 'backup', require: false
gem 'whenever', require: false
gem 'state_machine'
gem 'figaro'
gem 'sitemap_generator'
gem 'humanizer'
gem 'faraday'
gem 'acts-as-taggable-on', '~> 2.4.1'
gem 'gibbon'
gem 'twilio-ruby'
gem 'analytics-ruby', '~> 2.0.0', :require => 'segment/analytics'
# oauth
gem 'omniauth'
gem 'omniauth-douban-oauth2'
gem 'omniauth-weibo-oauth2', github: 'JevanWu/omniauth-weibo-oauth2'
gem 'omniauth-qq-connect'

gem 'enumerize'
gem 'virtus'

gem "rails-settings-cached", "~> 0.4.0"

# squash
gem 'squash_ruby', :require => 'squash/ruby'
gem 'squash_rails', :require => 'squash/rails'

# background jobs
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', require: nil

# used for email css styles sane
gem 'roadie'

# rails-4 upgrade
gem 'rails-observers'
gem 'sprockets-rails'
gem 'sprockets', '<= 2.11.0'

gem 'sass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails', '>= 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-sass', '~> 2.2.1.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'nprogress-rails'

gem 'closure_tree', github: 'ryancheung/closure_tree'

gem "activeadmin-sortable-tree", :github => "nebirhos/activeadmin-sortable-tree", :branch => "master"

gem 'phonelib', '~> 0.3.1'

gem 'mobylette'

gem 'draper', '~> 1.0'

gem 'ckeditor', github: 'ryancheung/ckeditor'
gem 'huali-blog', path: 'vendor/plugins/huali-blog', require: 'blog'

gem 'grape'

gem 'api-auth', github: 'ryancheung/api_auth'
gem 'rest-client'

gem 'huali_api', git: 'git@bitbucket.org:huali-store/huali_api.git', tag: 'v0.1.1', require: 'huali_agent_api'

gem 'flowplayer-rails', github: 'ryancheung/flowplayer-rails'

gem 'dalli'

gem 'omnicontacts'

gem 'sunspot_rails'

gem 'mechanize'

gem 'tiny_tds'
gem 'activerecord-sqlserver-adapter', '~> 4.0.0'

gem "highcharts-rails", "~> 3.0.0"

gem 'i18n', github: 'svenfuchs/i18n', tag: 'v0.6.10'

gem 'rqrcode'
gem 'chosen-rails'
gem "font-awesome-rails"

gem 'alipay', '~> 0.1.0'

#xml parser
gem 'actionpack-xml_parser'

# Map Region checker
gem 'border_patrol'

gem 'newrelic_rpm'

group :development, :test do
  gem 'rspec-rails', '>= 2.11.0'
  gem 'rspec-instafail'
  gem 'factory_girl_rails', '>= 4.0.0'
  gem 'forgery', git: 'https://github.com/zenhacks/forgery.git'
  gem 'sunspot_solr'
end

group :production, :staging do
  #puma
  gem 'puma'
end

group :development do
  gem 'rb-readline'
  gem 'thin', '>= 1.4.1'
  gem 'rb-fsevent', require: false
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'guard-spork'
  gem 'awesome_print'
  # pry setups
  gem 'pry', require: false
  gem 'bond'
  gem 'pry-doc'
  gem 'pry-docmore'
  gem 'pry-remote'
  gem 'pry-rescue'
  gem 'pry-byebug'
  gem 'pry-coolline'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'

  # Deployment
  gem 'capistrano', '~> 3.0', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'capistrano-sidekiq'
  gem "capistrano-db-tasks", github: 'ryancheung/capistrano-db-tasks', branch: 'postgresql-9.2', require: false
  gem "capistrano3-puma"

  gem 'railroady'
  gem "rails-erd"
  gem 'ruby-graphviz', require: 'graphviz' # Optional: only required for graphing
  gem 'meta_request', '0.2.1'
  gem "letter_opener"
end

group :test do
  gem 'shoulda-matchers'
  gem 'activerecord-nulldb-adapter'
  gem 'capybara', '>= 1.1.2'
  gem 'selenium-webdriver'
  gem 'spork-rails'
  gem 'simplecov', require: false
  gem 'email_spec', '>= 1.2.1'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'rr', require: false
end
