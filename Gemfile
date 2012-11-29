source 'http://ruby.taobao.org'

gem 'rails', '3.2.8'
gem 'pg', '>= 0.14.1'
gem 'devise', '>= 2.1.2'
gem 'activeadmin'
gem 'paperclip', '~> 3.0'
gem 'formtastic'
gem 'kramdown', '~>0.13'
gem 'friendly_id', '~> 4.0.1'
# backup, whenever probably should be isolated in a server setup script
gem 'backup', :require => false
gem 'whenever', :require => false

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.1.0.0'
end

group :development, :test do
  gem 'rspec-rails', '>= 2.11.0'
  gem 'rspec-instafail'
  gem 'factory_girl_rails', '>= 4.0.0'
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
  gem 'pry', :require => false
  gem 'awesome_print', :require => false
  gem 'capistrano', '~>2.0'
  gem 'capistrano-zen'
  gem 'railroady'
end

group :test do
  gem "shoulda-matchers"
  gem 'capybara', '>= 1.1.2'
  gem 'spork', '~> 1.0rc'
  gem 'simplecov', :require => false
  gem 'email_spec', '>= 1.2.1'
  gem 'database_cleaner', '>= 0.8.0'
end
