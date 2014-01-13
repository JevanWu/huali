source "http://ruby.taobao.org"
# source "http://bundler-api.herokuapp.com"
# source 'http://rubygems.org'

gem 'rails', '~> 4.0.0', github: 'rails/rails', branch: '4-0-stable'
gem 'pg', '>= 0.14.1'
gem 'devise', '3.0.0.rc'
gem 'devise-i18n'
gem 'cancan', '~> 1.0'
gem 'rails-i18n'
gem 'redis-rails', github: 'jodosha/redis-store'
gem 'activeadmin',         github: 'ryancheung/active_admin', ref: '54fb71c5415f7b1a7aa0cdde680ee882fa3b2d6f'
gem 'ransack',             github: 'ernie/ransack',         branch: 'rails-4'
gem 'inherited_resources', github: 'josevalim/inherited_resources'
gem 'formtastic',          github: 'justinfrench/formtastic'
gem 'axlsx'
gem 'paperclip', '~> 3.0'
gem 'simple_form', github: 'plataformatec/simple_form', branch: 'master'
gem 'kramdown', '~> 0.13'
gem 'friendly_id', github: 'zenhacks/friendly_id'
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
gem 'analytics-ruby'
# oauth
gem 'omniauth'
gem 'omniauth-douban-oauth2'
gem 'omniauth-weibo-oauth2'
gem 'omniauth-qq-connect'

gem 'enumerize'
gem 'virtus'

gem "rails-settings-cached", github: "huacnlee/rails-settings-cached"

# squash
gem 'squash_ruby', git: 'https://github.com/SquareSquash/ruby.git', require: 'squash/ruby'
gem 'squash_rails', git: 'https://github.com/SquareSquash/rails.git', require: 'squash/rails'

# background jobs
gem 'sidekiq', '~> 2.9'
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', require: nil

# used for email css styles sane
gem 'roadie'

# rails-4 upgrade
gem 'rails-observers', github: 'rails/rails-observers'
gem 'sprockets-rails', github: 'rails/sprockets-rails', require: 'sprockets/railtie'

gem 'sass-rails', github: 'rails/sass-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails', '>= 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'bootstrap-sass', '~> 2.2.1.1'
# gem 'turbo-sprockets-rails3'

gem 'closure_tree'

gem "activeadmin-sortable-tree",
  github: "ryancheung/activeadmin-sortable-tree"

gem 'phonelib', '~> 0.2.4'

gem 'mobylette'

gem 'draper', '~> 1.0'

gem 'ckeditor', github: 'ryancheung/ckeditor'
gem 'huali-blog', path: 'vendor/plugins/huali-blog', require: 'blog'

gem 'grape'

gem 'api-auth', github: 'ryancheung/api_auth'
gem 'rest-client'

group :development, :test do
  gem 'rspec-rails', '>= 2.11.0'
  gem 'rspec-instafail'
  gem 'factory_girl_rails', '>= 4.0.0'
  gem 'forgery', git: 'https://github.com/zenhacks/forgery.git'
end

group :production, :staging do
  gem 'unicorn'
  gem 'newrelic_rpm'
end

group :development do
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
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
  gem 'capistrano', '~>2.0'
  gem 'capistrano-zen', git: 'https://github.com/zenhacks/capistrano-zen.git', require: false
  gem 'railroady'
  gem "rails-erd"
  gem 'ruby-graphviz', require: 'graphviz' # Optional: only required for graphing
  gem 'meta_request', '0.2.1'
  gem "letter_opener"
  gem 'rack-mini-profiler', git: 'https://github.com/SamSaffron/MiniProfiler.git'
end

group :test do
  gem 'shoulda-matchers'
  gem 'activerecord-nulldb-adapter', github: 'blaet/nulldb', branch: 'support_enable_extension'
  gem 'capybara', '>= 1.1.2'
  gem 'selenium-webdriver'
  gem 'spork', '~> 1.0rc'
  gem 'simplecov', require: false
  gem 'email_spec', '>= 1.2.1'
  gem 'database_cleaner', '>= 0.8.0'
  gem 'rr', require: false
end
