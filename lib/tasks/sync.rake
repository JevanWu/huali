require 'yaml'

DB_FILE_PATH = Rails.root + "config/database.yml"

dbconfig = YAML.load_file(DB_FILE_PATH)
if dbconfig["development"]
  db_name = dbconfig["development"]["database"]
  db_username = dbconfig["development"]["username"]
  db_password = dbconfig["development"]["password"]
end

if dbconfig["production"]
  production_username = dbconfig["production"]["username"]
  production_password = dbconfig["production"]["password"]
  production_db_name = dbconfig["production"]["database"]
end

ssh_host = 'maxwell'

taps_user = "changanhua"
taps_password = "3EBhzuiqrN8tSR"
deploy_user = "deployer"
repo_name = "changanhua-production"

namespace :db do

  desc "pull the server production database to local development database"
  task :pull do
    table_cmd = "taps pull postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://#{taps_user}:#{taps_password}@#{ssh_host}:5000"
    table_cmd << " --tables " << ENV['table'] unless ENV['table'].nil?
    system(table_cmd)
  end

  desc "push the local development database to the server production database"
  task :push do
    table_cmd = "taps push postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://#{taps_user}:#{taps_password}@#{ssh_host}:5000"
    table_cmd << " --tables " << ENV['table'] unless ENV['table'].nil?
    system(table_cmd)
  end

end


namespace :taps do

  desc "open remote server taps service"
  task :open do
    system("ssh -f #{deploy_user}@#{ssh_host} \"taps server postgres://#{production_username}:#{production_password}@localhost/#{production_db_name} #{taps_user} #{taps_password}\"")
    p $?.exitstatus ? "succeeded" : "failed"
  end

  desc "close remote server taps service"
  task :close do
    system("ssh -f #{deploy_user}@#{ssh_host} \"pkill taps\"")
    p $?.exitstatus ? "succeeded" : "failed"
  end

end

namespace :assets do

  desc "pull the assets from the server"
  task :pull do
    system("rsync -rvz #{deploy_user}@#{ssh_host}:~/repositories/#{repo_name}/shared/system/ public/system")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' #{deploy_user}@#{ssh_host}:~/repositories/#{repo_name}/shared/ public/")
  end


  desc "push the assets to the server"
  task :push do
    system("rsync -rvz public/system #{deploy_user}@#{ssh_host}:~/repositories/#{repo_name}/shared/")
    system("rsync -rvz --include '*.txt' --include '*.ico' --exclude '*' public/ #{deploy_user}@#{ssh_host}:~/repositories/#{repo_name}/shared/")
  end

end

