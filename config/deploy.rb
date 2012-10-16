set :application, "changanhua"

# Use Git as Version Control System
set :scm, :git
set :repository, "git@github.com:zenhacks/changanhua.git"
set :branch, 'master'

# HTTP Server & App Server & DB Server resides at emoo
server 'lua', :web, :app, :db, :primary => true
set :user, 'yangchenyun'
set :deploy_to, "/home/#{user}/repositories/#{application}"

# enable prompt for password
# default_run_options[:pty] = true

# access github.com using as the local user
ssh_options[:forward_agent] = true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

set :keep_releases, 10

namespace :unicorn do
 after "deploy:setup", "unicorn:config"
end

namespace :check do
  desc "Make sure local git is in sync with remote."
  task :revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
      puts "WARNING: HEAD is not the same as origin/#{branch}"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "check:revision"
  before "deploy:migrations", "check:revision"
  before "deploy:cold", "check:revision"
end
