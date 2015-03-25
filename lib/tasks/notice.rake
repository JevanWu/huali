namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms_and_email: :environment do
    Sms.delay.date_wait_make_order(Date.current, '15026667992', '18305662999')
    Notify.delay.date_wait_make_order_email(Date.current.tomorrow, "584546358@qq.com", "307795911@qq.com", 'ryancheung.go@gmail.com')
  end

  desc "Notify about Today's Summary"
  task today_order_summary_email: :environment do
    Notify.delay.date_summary_email(Date.current, *mail_list)
    Notify.delay.date_summary_email(Date.current, mail_list)
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
    Notify.delay.ready_to_ship_orders_today(Date.current, 'ella@hua.li', 'apple@hua.li')
  end

  def mail_list
    ['john@hua.li', 'lin@hua.li', 'ella@hua.li', 'tyler@hua.li', 'xinliang@hua.li', 'ryan@hua.li']
  end

  desc "Notify about orders shipping failed throught API"
  task api_shipping_failed_orders: :environment do
    Notify.delay.api_shipping_failed_orders('ella@hua.li', 'ryan@hua.li', 'terry@hua.li')
  end

  desc "Email all orders"
  task all_orders_excel_email: :environment do
    Notify.delay.all_orders_excel_email('JohnLoong@gmail.com')
  end
end
