load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"

set :application, "changanhua"
set :domain, "www.changanflowers.com changanflowers.com"

# Use Git as Version Control System
set :scm, :git
set :repository, "git@github.com:zenhacks/changanhua.git"
set :branch, 'master'

# HTTP Server & App Server & DB Server resides at emoo
# lua - 42.121.3.105, aliyun - steven
# server '42.121.3.105:1982', :web, :app, :db, :primary => true

# emoo - 74.207.254.157, linode tokyo
server '74.207.254.157:1982', :web, :app, :db, :primary => true

set :user, 'deploy'
set :group, 'deploy'
set :deploy_to, "/home/#{user}/repositories/#{application}"

# enable prompt for password
default_run_options[:pty] = true

# access github.com using as the local user
ssh_options[:forward_agent] = true

# keep only last 5 commit
# set :keep_releases, 5
after "deploy:restart", "deploy:cleanup"