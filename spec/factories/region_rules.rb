# == Schema Information
#
# Table name: region_rules
#
#  area_ids     :text
#  city_ids     :text
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  name         :string(255)
#  product_id   :integer
#  province_ids :text
#  type         :string(255)
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_region_rules_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :local_region_rule do
    province_ids []
    city_ids []
    area_ids []
    product
  end

  factory :default_region_rule do
    sequence(:name) { |n| "Default#{n}" }
    province_ids []
    city_ids []
    area_ids []
  end
end
