namespace :notice do
  task sales_report: :environment do
    Notify.delay.sales_report('tony@tzgpartners.com', 'ben@tzgpartners.com', 'john@hua.li', 'lin@hua.li', 'tyler@hua.li', 'ryan@hua.li')
  end
end
