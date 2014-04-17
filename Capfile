load 'deploy'
load 'deploy/assets'

set :config_path, File.expand_path(File.dirname(__FILE__), 'config')
set :db_backup_path, '/var/backups/db'

require 'capistrano-zen/utils'
require 'capistrano-zen/nginx'
require 'capistrano-zen/nodejs'
require 'capistrano-zen/postgresql'
require 'capistrano-zen/mysql'
require 'capistrano-zen/rbenv'
require 'capistrano-zen/unicorn'
require 'capistrano-zen/config'

require "whenever/capistrano"
set :whenever_roles, [:db, :app]

require 'squash/rails/capistrano2'

# Use Git as Version Control System
set :scm, :git
set :repository, "git@git.zenhacks.org:yangchenyun/huali.git"
set :branch, 'master'

# keep a remote cache to avoid checking out everytime
set :deploy_via, :remote_cache

# enable prompt for password
default_run_options[:pty] = true

# try_sudo will not use sudo by default
set :use_sudo, false

# access github.com using as the local user
ssh_options[:forward_agent] = true
set :user, 'deployer'
set :group, 'admin'

set :git_enable_submodules, 1

set :application, "huali"

# multistage settings
task :production do
  set :domain, "en.hua.li www.hua.li hua.li *.hua.li hualistore.com www.hualistore.com"
  set :unicorn_workers, 18

  # maxwell - 42.121.119.155', aliyun
  server '42.121.119.155', :web, :app, :db, primary: true
  set :rails_env, "production"

  set :deploy_to, "/home/#{user}/repositories/#{application}-production"

  require 'sidekiq/capistrano'
end

task :staging do
  set :domain, "en.staging.hua.li staging.hua.li"
  set :unicorn_workers, 1

  # lua - 42.121.3.105, aliyun - steven
  server '42.121.3.105', :web, :app, :db, primary: true
  set :rails_env, "staging"

  set :branch, 'staging'
  set :deploy_to, "/home/#{user}/repositories/#{application}-staging"
end

namespace :deploy do
  # start/stop/restart application
  task :start, roles: :app, except: { no_release: true } do
  	unicorn.start
  end

  task :stop, roles: :app, except: { no_release: true } do
  	unicorn.stop
  end

  task :restart, roles: :app, except: { no_release: true } do
  	unicorn.upgrade
  end

  task :bundle, roles: :app, except: { no_release: true } do
    run "cd #{release_path} && bundle install --without=development test"
  end
  before "deploy:finalize_update", "deploy:bundle"
end

namespace :sitemap do
  task :refresh do
    if rails_env == 'staging' 
      run "cd #{release_path} && bundle exec rake sitemap:refresh"
      run "gunzip -c #{release_path}/public/sitemap.xml.gz>#{release_path}/public/sitemap.xml"
    end
  end
end

after "deploy:install",
  "nginx:install",
  "nodejs:install",
  "rbenv:install",
  "dev_lib:install",
  "pg:install"

after "deploy:setup",
  "nginx:setup:unicorn",
  "pg:setup",
  "pg:init",
  "unicorn:setup",
  "config:setup"

# dump database before a new successful release
before "config:db:symlink", "pg:dump"
after "deploy:finalize_update",
  "config:db:symlink",
  "config:env:symlink",
  "sitemap:refresh"

# CKEditor
desc 'copy ckeditor nondigest assets'
task :copy_nondigest_assets, roles: :app do
  run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} ckeditor:copy_nondigest_assets"
end
after 'deploy:assets:precompile', 'copy_nondigest_assets'

