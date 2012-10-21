require 'yaml'
DB_FILE_PATH = Rails.root + "config/database.yml"
dbconfig = YAML.load_file(DB_FILE_PATH)
db_name = dbconfig["development"]["database"]
db_username = dbconfig["development"]["username"]
db_password = dbconfig["development"]["password"]

namespace :db do

  desc "pull the production database from the changanflowers.com server"
  task :pull => :environment do
    table_cmd = "taps pull postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://httpuser:httppassword@changanflowers.com:5000"
    unless ENV['table'].nil?
      table_cmd << " --tables " << ENV['table']
    end
    exec(table_cmd)
  end

  desc "push the development database to the changanflowers.com server"
  task :push => :environment do
    table_cmd = "taps push postgres://#{db_username}:#{db_password}@localhost/#{db_name} http://httpuser:httppassword@changanflowers.com:5000"
    unless ENV['table'].nil?
      table_cmd << " --tables " << ENV['table']
    end
    exec(table_cmd)
  end
end
