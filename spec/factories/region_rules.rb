# == Schema Information
#
# Table name: region_rules
#
#  area_ids     :string(255)
#  city_ids     :string(255)
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  product_id   :integer
#  province_ids :string(255)
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_region_rules_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :region_rule do
    province_ids Province.limit(20).select("id").map(&:id)
    city_ids City.limit(200).select("id").map(&:id)
    area_ids Area.limit(2000).select("id").map(&:id)
    product
  end
end
