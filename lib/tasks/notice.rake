namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms: :environment do
    Sms.delay.date_wait_make_order(Date.current, '15026667992', '18305662999')
  end

  desc "Notify about Today's Summary"
  task today_order_summary_email: :environment do
    Notify.delay.date_summary_email(Date.current, *mail_list)
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

  desc "Notify about orders have delivery date today"
  task ready_to_ship_orders_today: :environment do
    Notify.delay.ready_to_ship_orders_today
  end

  def mail_list
    ['john@hua.li', 'lin@hua.li', 'ella@hua.li']
  end
end
