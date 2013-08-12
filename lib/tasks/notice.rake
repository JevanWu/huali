namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms: :environment do
    Sms.delay.date_wait_make_order(Date.current, '13671898460', '15026667992', '15900646773', '18305662999')
  end

  desc "Notify about Today's Summary"
  task today_order_summary_email: :environment do
    Notify.delay.date_summary_email(Date.current, 'team@hua.li')
  end

  desc "Notify about heavy day preparation"
  task :busy_day_email, [:topic, :start_date, :end_date] => :environment do |t, args|
    Notify.delay.product_day_email_wait_delivery(args[:topic],
                                   args[:start_date],
                                   args[:end_date],
                                   'team@hua.li')

    Notify.delay.product_day_email_delivered(args[:topic],
                                   args[:start_date],
                                   args[:end_date],
                                   'team@hua.li')
  end

  desc "Notify about unpaid orders today"
  task unpaid_orders_email: :environment do
    Notify.delay.unpaid_orders_email
  end
end
