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
  after "deploy:install", "nginx:install"
  after "deploy:install", "nodejs:install"
  after "deploy:install", "rbenv:install"

  # after "deploy:setup", "nginx:setup"
end
