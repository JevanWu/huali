namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms: :environment do
    Sms.delay.date_wait_make_order(Date.current, '13671898460', '15026667992', '15900646773')
  end

  desc "Notify about Today's Summary"
  task today_order_summary_email: :environment do
    Notify.delay.date_summary_email(Date.current, 'team@hua.li')
  end

  desc "Notify about Mother's Day Preparation"
  task product_day_email: :environment do
    Notify.delay.product_day_email('team@hua.li')
  end

  desc "Notify about unpaid orders today"
  task unpaid_orders_email: :environment do
    Notify.delay.unpaid_orders_email
  end
end
