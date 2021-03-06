# == Schema Information
#
# Table name: region_rules
#
#  area_ids            :text
#  city_ids            :text
#  created_at          :datetime         not null
#  id                  :integer          not null, primary key
#  name                :string(255)
#  province_ids        :text
#  region_rulable_id   :integer
#  region_rulable_type :string(255)
#  type                :string(255)
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_region_rules_on_region_rulable_id  (region_rulable_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :local_region_rule do
    province_ids []
    city_ids []
    area_ids []
  end

  factory :default_region_rule do
    sequence(:name) { |n| "Default#{n}" }
    province_ids []
    city_ids []
    area_ids []
  end
end
