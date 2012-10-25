require 'yaml'
DB_FILE_PATH = Rails.root + "config/database.yml"
dbconfig = YAML.load_file(DB_FILE_PATH)
db_name = dbconfig["development"]["database"]
db_username = dbconfig["development"]["username"]
db_password = dbconfig["development"]["password"]

namespace :db do

  desc "pull the production database from the changanflowers.com server"
  task :pull do
    table_cmd = "taps pull postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://httpuser:httppassword@changanflowers.com:5000"
    unless ENV['table'].nil?
      table_cmd << " --tables " << ENV['table']
    end
    system(table_cmd)
  end

  desc "push the development database to the changanflowers.com server"
  task :push do
    table_cmd = "taps push postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://httpuser:httppassword@changanflowers.com:5000"
    unless ENV['table'].nil?
      table_cmd << " --tables " << ENV['table']
    end
    system(table_cmd)
  end
end


namespace :taps do

  desc "open remote server taps service"
  task :open do
    system('ssh -f deploy@easymoo "taps server postgres://changanhua:hananokorunrun@localhost/changanhua_production httpuser httppassword"')
    $?.exitstatus ? puts("succeeded") : puts("failed")
    #p code ? "taps opened" : "failed to open taps"
  end

  desc "close remote server taps service"
  task :close do
    system('ssh -f deploy@easymoo "pkill taps"')
    $?.exitstatus ? puts("succeeded") : puts("failed")
    #p code ? "taps closed" : "failed to close taps"
  end
end
