# encoding: utf-8
namespace :migrate do
  desc "Migrate old region rule to new Global Region Rule"
  task region_rule: :environment do
    new_region_rule = OpenStruct.new
    new_region_rule.province_ids = Province.available.select(:id).map(&:id)
    new_region_rule.city_ids = City.available.select(:id).map(&:id)
    new_region_rule.area_ids = Area.available.select(:id).map(&:id)

    Settings.region_rule = new_region_rule
  end
end
