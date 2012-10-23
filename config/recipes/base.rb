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
end

after "deploy:install",
  "nginx:install",
  "nodejs:install",
  "rbenv:install",
  "dev_lib:install",
  "pg:install"

after "deploy:setup", 
  "nginx:setup", 
  "pg:setup",
  "pg:create_database",
  "unicorn:setup"
  
after "deploy:finalize_update", "pg:symlink"
