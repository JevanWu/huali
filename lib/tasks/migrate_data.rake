# encoding: utf-8
namespace :migrate do
  desc "Migrate old region rule to new Global Region Rule"
  task region_rule: :environment do
    default_name = "默认地域规则"
    unless DefaultRegionRule.where(name: default_name).exists?
      DefaultRegionRule.create(name: default_name,
                               province_ids: Province.available.select(:id).map { |p| p.id.to_s },
                               city_ids: City.available.select(:id).map { |c| c.id.to_s },
                               area_ids: Area.available.select(:id).map { |a| a.id.to_s })
    end

    default_rule = DefaultRegionRule.where(name: default_name).first

    Product.unscoped.each do |product|
      product.default_region_rule = default_rule
      product.save(validate: false)
    end
  end

  desc "Migrate old date rule to new Global Date Rule"
  task date_rule: :environment do
    default_name = "默认时间规则"
    unless DefaultDateRule.where(name: default_name).exists?
      DefaultDateRule.create(name: default_name,
                             start_date: nil,
                             period_length: "+2M",
                             included_dates: [],
                             excluded_dates: [],
                             excluded_weekdays: ["0", "1"])

    end

    default_rule = DefaultDateRule.where(name: default_name).first

    Product.unscoped.each do |product|
      product.default_date_rule = default_rule
      product.save(validate: false)
    end
  end

  desc "Migrate global settings"
  task global_settings: :environment do
    Setting.expected_date_notice = "端午节周末接受订单。订单除周日，周一外均可送达."
    Setting.head_service_notice = "For English Service: 400-087-8899"
  end

  desc "Fix mistyped phones"
  task fix_mistyped_phones: :environment do
    Order.unscoped.each do |o|
      phone = o.sender_phone_before_type_cast
      parsed = Phonelib.parse(phone)

      if parsed.valid?# && o.state != 'void' && o.state != 'completed'
        if phone =~ /^01\-/ || phone =~ /^1\-/
          puts "Old: #{phone}"
          if phone =~ /^01\-/
            phone = phone.sub(/^0(1\-)/, '+\1')
          elsif phone =~ /^1\-/
            phone = phone.sub(/^(1\-)/, '+\1')
          end

          o.sender_phone = phone
          o.save(validate: false)
          puts "Updated: #{phone}"
        end
      end
    end;
    puts "done";
  end

  desc "Migrate product sold total to monthly sold model"
  task product_sold_total: :environment do
    Product.unscoped.each do |product|
      product.update_monthly_sold(product.sold_total)
    end
  end

  desc "improt order to erp"
  task import_order: :environment do
    start_date = "2014-05-26".to_date
    end_date = "2014-06-23".to_date

    orders = Order.includes({ line_items: :product }, :transactions, :shipments, :ship_method).
      where(delivery_date: start_date..end_date).
      where(state: ["wait_confirm", "completed"]).
      where(kind: ['normal', 'taobao', 'tmall']).to_a

    orders.each do |order|
      Erp::OrderImporter.new(order).import
    end
  end
end
