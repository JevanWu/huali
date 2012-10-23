def template(from, to)
  erb = File.read(File.expand_path("../tmpls/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
  end
  after "deploy:install",
    "nginx:install",
    "nodejs:install",
    "rbenv:install",
    "dev_lib:install"
    "postgresql:install"

  # after "deploy:setup", "nginx:setup"
  # after "deploy:setup", "postgresql:create_database"
  # after "deploy:setup", "postgresql:setup"
  # after "deploy:finalize_update", "postgresql:symlink"
  # after "deploy:setup", "unicorn:setup"
end
