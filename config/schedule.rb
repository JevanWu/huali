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

every :day, at: '0:01 am' do
  rake 'shipment:auto_confirm_received'
end

every :day, at: '5:45 pm' do
  rake 'cleanup:guests'
  rake 'cleanup:orders'
  rake 'cleanup:transactions'
end

every :day, at: '3:00 am' do
  rake "sitemap:refresh"
end

every 3.hours do
  rake "erp:check_shipped_orders"
end

every :day, at: '9:00 pm' do
  rake "notice:today_order_sms_and_email"
end

every :day, at: '11:59 pm' do
  rake "notice:today_order_summary_email"
end

every 2.hours do
  rake "notice:unpaid_orders_email"
end

every 30.minutes do
  rake "sidekiq:clean_needless_retries"
end

every :day, at: '4:00 am' do
  rake "unicorn:restart_workers"
end

every :day, at: '1:00 pm' do
  rake "notice:ready_to_ship_orders_today"
end

#every 1.hour do
  #rake "notice:busy_day_email[情人节,2014-02-01,2014-02-16]"
#end

every 30.minutes do
  rake "notice:api_shipping_failed_orders"
end

every :day, at: '2:00 am' do
  rake "notice:all_orders_excel_email"
end

every :year do
  rake "huali_point:annual_reset_and_accounting"
end

every :month do
  rake 'cleanup:reset_sold_total'
end

every :day, at: '11:50 pm' do
  rake "notice:sales_report"
end
