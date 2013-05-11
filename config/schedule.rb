# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#

set :output, File.expand_path("../../log/cron_log.log", __FILE__)

every :day, at: '1:00 am' do
  command "backup perform -t db_backup"
end

every :day, at: '2:00 am' do
  command "backup perform -t asset_backup"
end

every :day, at: '5:45 pm' do
  rake 'cleanup:guests'
  rake 'cleanup:orders'
  rake 'cleanup:transactions'
end

every :day, at: '3:00 am' do
  rake "sitemap:refresh"
end

every :day, at: '8:00 am' do
  rake "notice:today_order_sms"
end

every :day, at: '11:59 pm' do
  rake "notice:today_order_summary_email"
end
