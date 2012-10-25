require 'yaml'
DB_FILE_PATH = Rails.root + "config/database.yml"
dbconfig = YAML.load_file(DB_FILE_PATH)
db_name = dbconfig["development"]["database"]
db_username = dbconfig["development"]["username"]
db_password = dbconfig["development"]["password"]
taps_user = "httpuser"
taps_password = "httppassword"
deploy_user = "deploy"
changanflowers_server = "changanflowers.com"
ssh_host = "easymoo"

namespace :db do

  desc "pull the production database from the changanflowers.com server"
  task :pull do
    table_cmd = "taps pull postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://#{taps_user}:#{taps_password}@#{changanflowers_server}:5000"
    table_cmd << " --tables " << ENV['table'] unless ENV['table'].nil?
    system(table_cmd)
  end

  desc "push the development database to the changanflowers.com server"
  task :push do
    table_cmd = "taps push postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://#{taps_user}:#{taps_password}@#{changanflowers_server}:5000"
    table_cmd << " --tables " << ENV['table'] unless ENV['table'].nil?
    system(table_cmd)
  end
end


namespace :taps do

  desc "open remote server taps service"
  task :open do
    system("ssh -f #{deploy_user}@#{ssh_host} \"taps server postgres://changanhua:hananokorunrun@localhost/changanhua_production #{taps_user} #{taps_password}\"")
    p $?.exitstatus ? "succeeded" : "failed"
  end

  desc "close remote server taps service"
  task :close do
    system("ssh -f #{deploy_user}@#{ssh_host} \"pkill taps\"")
    p $?.exitstatus ? "succeeded" : "failed"
  end
end

namespace :assets do

  desc "pull the assets from the changanflowers.com server"
  task :pull do
    system("rsync -rvz deploy@easymoo:/home/deploy/repositories/changanhua/shared/system/ public/system")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' deploy@easymoo:/home/deploy/repositories/changanhua/shared/ public/")
  end


  desc "push the assets to the changanflowers.com server"
  task :push do
    system("rsync -rvz public/system deploy@easymoo:/home/deploy/repositories/changanhua/shared/system/")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' public/ deploy@easymoo:/home/deploy/repositories/changanhua/shared/")
  end
end
