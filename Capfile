# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# require 'capistrano/rvm'
require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano-db-tasks'
require 'capistrano/rails/migrations'
require 'whenever/capistrano'
require 'capistrano/sitemap_generator'

require 'capistrano/sidekiq'

require 'capistrano/puma'
require 'capistrano/puma/jungle'
# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
