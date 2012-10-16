namespace :nodejs do
  desc "Install the latest relase of Node.js"
  # Reference
  # https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
  task :install, roles: :app do
    run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nodejs npm"
  end
end