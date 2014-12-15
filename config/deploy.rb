# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'huali'
set :repo_url, 'git@bitbucket.org:huali-store/huali.git'

set :rails_env, fetch(:stage) == :staging ? 'staging' : 'production'

# Default branch is :master
set :branch, fetch(:rails_env) == 'staging' ? :staging : :master

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/deployer/repositories/#{fetch(:application)}-#{fetch(:rails_env)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml config/puma.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# rbenv configuration
set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p247'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for default_env is {}
# set :default_env, {}

# Default value for keep_releases is 5
# set :keep_releases, 5
set :sidekiq_config, "#{fetch(:deploy_to)}/current/config/sidekiq.yml"

set :assets_dir, %w(public/system)

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :service, "unicorn_huali upgrade"
      invoke "puma:restart"
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

  # Only refresh sitemap on production servers
  after :restart, 'sitemap:refresh' unless fetch(:rails_env) == 'staging'

  # Custom task to unzip generated sitemap.xml.gz file
  after 'sitemap:refresh', 'sitemap:unzip' do
    on roles(:app), in: :sequence do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :gunzip, "-fc public/sitemap.xml.gz > public/sitemap.xml"
        end
      end
    end
  end

  #refresh paperclip missing_styles
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'paperclip:refresh:missing_styles'
        end
      end
    end
  end

end

after("deploy:restart", "deploy:build_missing_paperclip_styles")

# CKEditor
desc 'Copy ckeditor nondigest assets'
task :copy_nondigest_assets do
  on roles(:app), in: :sequence do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, 'ckeditor:copy_nondigest_assets'
      end
    end
  end
end

after 'deploy:assets:precompile', 'copy_nondigest_assets'
