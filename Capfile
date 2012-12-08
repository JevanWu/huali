load 'deploy'
load 'deploy/assets'

set :db_config_path, File.expand_path(File.dirname(__FILE__), 'config')
set :db_backup_path, '/var/backups/db'

require 'capistrano-zen/utils'
require 'capistrano-zen/nginx'
require 'capistrano-zen/nodejs'
require 'capistrano-zen/postgresql'
require 'capistrano-zen/mysql'
require 'capistrano-zen/rbenv'
require 'capistrano-zen/unicorn'

require "whenever/capistrano"
set :whenever_roles, [:db, :app]

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

set :application, "huali"

# multistage settings
task :production do
  set :domain, "en.hua.li www.hua.li hua.li *.hua.li"
  set :unicorn_workers, 3

  # maxwell - 42.121.119.155', aliyun
  server '42.121.119.155', :web, :app, :db, :primary => true
  set :rails_env, "production"

  set :deploy_to, "/home/#{user}/repositories/#{application}-production"
end

task :staging do
  set :domain, "en.staging.hua.li staging.hua.li"
  set :unicorn_workers, 1

  # lua - 42.121.3.105, aliyun - steven
  server '42.121.3.105', :web, :app, :db, :primary => true
  set :rails_env, "staging"

  set :branch, 'staging'
  set :deploy_to, "/home/#{user}/repositories/#{application}-staging"
end
task :easymoo do
  set :domain, "hua.li www.hua.li"

  # emoo - 74.207.254.157, emoo - linode
  server '74.207.254.157:1982', :web, :app, :db, :primary => true
  set :rails_env, "production"

  set :deploy_to, "/home/#{user}/repositories/#{application}"
end

namespace :deploy do
  # start/stop/restart application
  task :start, :roles => :app, :except => { :no_release => true } do
  	unicorn.start
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
  	unicorn.stop
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
  	unicorn.upgrade
  end

  task :bundle, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle install"
  end
  after "deploy:finalize_update", "deploy:bundle"
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
  "unicorn:setup"

# dump database before a new successful release
before "pg:symlink", "pg:dump"
after "deploy:finalize_update", "pg:symlink"
