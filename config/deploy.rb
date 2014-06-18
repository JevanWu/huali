# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'huali'
set :repo_url, 'git@git.zenhacks.org:yangchenyun/huali.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "~/repositories/#{fetch(:application)}-#{fetch(:stage)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml config/unicorn.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# rbenv configuration
set :rbenv_type, fetch(:stage) == :staging ? :system : :user # staing server use system rbenv setup
set :rbenv_ruby, '2.0.0-p247'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for default_env is {}
# set :default_env, {}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :service, "unicorn_huali upgrade"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

# CKEditor
desc 'Copy ckeditor nondigest assets'
task :copy_nondigest_assets do
  on roles(:app), in: :sequence do
    within release_path do
      with rails_env: :production do
        execute :rake, 'ckeditor:copy_nondigest_assets'
      end
    end
  end
end

after 'deploy:assets:precompile', 'copy_nondigest_assets'
