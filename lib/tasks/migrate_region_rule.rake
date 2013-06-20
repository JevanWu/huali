# encoding: utf-8
namespace :migrate do
  desc "Migrate old region rule to new Global Region Rule"
  task region_rule: :environment do
    default_name = "默认地域规则"
    unless DefaultRegionRule.where(name: default_name).exists?
      DefaultRegionRule.create(name: default_name,
                               province_ids: Province.available.select(:id).map(&:id),
                               city_ids: City.available.select(:id).map(&:id),
                               area_ids: Area.available.select(:id).map(&:id))
    end

    default_rule = DefaultRegionRule.where(name: default_name).first

    Product.unscoped.each do |product|
      product.default_region_rule = default_rule
      product.save(validate: false)
    end
  end
end
