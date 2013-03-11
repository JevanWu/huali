namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms: :environment do
    Sms.date_wait_make_order(Date.current, '13671898460')
  end
end
