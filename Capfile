load 'deploy'
load 'deploy/assets'

set :pg_config_path, File.expand_path(File.dirname(__FILE__), 'config')

require 'capistrano-zen/utils'
require 'capistrano-zen/nginx'
require 'capistrano-zen/nodejs'
require 'capistrano-zen/postgresql'
require 'capistrano-zen/rbenv'
require 'capistrano-zen/unicorn'

# Use Git as Version Control System
set :scm, :git
set :repository, "git@github.com:zenhacks/huali.git"
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

set :unicorn_workers, 3

set :pg_backup_path, '/var/backups/postgresql'

# multistage settings
task :production do
  set :domain, "hua.li www.hua.li"

  # maxwell - 42.121.119.155', aliyun
  server '42.121.119.155', :web, :app, :db, :primary => true
  set :rails_env, "production"

  set :deploy_to, "/home/#{user}/repositories/#{application}-production"
end

task :staging do
  set :domain, "staging.hua.li"

  # lua - 42.121.3.105, aliyun - steven
  server '42.121.3.105:1982', :web, :app, :db, :primary => true
  set :rails_env, "staging"

  set :branch, 'staging'
  set :deploy_to, "/home/#{user}/repositories/#{application}-staging"
end
task :easymoo do
  set :domain, "hua.li www.hua.li"

  # lua - 74.207.254.157, emoo - linode
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
