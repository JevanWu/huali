set :application, "changanhua"

# Use Git as Version Control System
set :scm, :git
set :repository, "git@github.com:zenhacks/changanhua.git"
set :branch 'master'

# HTTP Server & App Server & DB Server resides at emoo
server 'emoo', :web, :app, :db, :primary => true
set :user, 'deploy'
set :deploy_to "/home/#{user}/repositories/changanhua"

# enable prompt for password
default_run_options[:pty] = true

# access github.com using as the local user
ssh_options[:forward_agent] = true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
