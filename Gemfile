source "http://ruby.taobao.org"
# source "http://bundler-api.herokuapp.com"
# source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'pg', '>= 0.14.1'
gem 'devise', '>= 2.1.2'
gem 'devise-i18n'
gem 'cancan', '~> 1.0'
gem 'rails-i18n'
gem 'redis-rails'
gem 'activeadmin'
gem 'paperclip', '~> 3.0'
gem 'formtastic'
gem 'simple_form'
gem 'kramdown', '~> 0.13'
gem 'friendly_id', '~> 4.0.1'
# backup, whenever probably should be isolated in a server setup script
gem 'backup', :require => false
gem 'whenever', :require => false
gem 'state_machine'
gem 'rack-mini-profiler'
gem 'figaro'
gem 'sitemap_generator'
gem 'humanizer'
gem 'faraday'

# squash
gem 'squash_ruby', git: 'https://github.com/SquareSquash/ruby.git', require: 'squash/ruby'
gem 'squash_rails', git: 'https://github.com/SquareSquash/rails.git', require: 'squash/rails'

# background jobs
gem 'sidekiq', git: 'https://github.com/mperham/sidekiq.git'
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', :require => nil


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'
  # haml > 4.0 doesn't register haml as handlers for action mailer
  gem 'haml', '~> 3.0'
  gem 'haml-rails'
  gem 'jquery-ui-rails', git: 'https://github.com/yangchenyun/jquery-ui-rails.git'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.2.1.1'
  gem 'roadie'
end

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
  gem 'rb-fsevent', :require => false
  gem 'growl'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'guard-spork'
  gem 'awesome_print'
  # pry setups
  gem 'pry', :require => false
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'pry-rails'
  gem 'pry-coolline'
  gem 'better_errors', :git => 'https://github.com/charliesome/better_errors.git'
  gem 'binding_of_caller'
  gem 'annotate', :git => 'https://github.com/ctran/annotate_models.git'
  gem 'capistrano', '~>2.0'
  gem 'capistrano-zen', git: 'https://github.com/zenhacks/capistrano-zen.git', :require => false
  gem 'railroady'
  gem 'ruby-graphviz', :require => 'graphviz' # Optional: only required for graphing
  gem 'meta_request', '0.2.1'
end

group :test do
  gem "shoulda-matchers"
  gem 'capybara', '>= 1.1.2'
  gem 'spork', '~> 1.0rc'
  gem 'simplecov', :require => false
  gem 'email_spec', '>= 1.2.1'
  gem 'database_cleaner', '>= 0.8.0'
end
