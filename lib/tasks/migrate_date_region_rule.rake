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
                             end_date: nil,
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
end
