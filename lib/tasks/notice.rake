namespace :notice do
  desc "Notify Danqing Today's Order"
  task today_order_sms: :environment do
    Sms.delay.date_wait_make_order(Date.current, '13671898460', '15026667992', '15900646773')
  end

  desc "Notify about Today's Summary"
  task today_order_summary_email: :environment do
    Notify.delay.date_summary_email(Date.current, 'team@zenhacks.org')
  end

  desc "Notify about Mother's Day Preparation"
  task product_day_email: :environment do
    Notify.delay.product_day_email('team@zenhacks.org')
  end
end
