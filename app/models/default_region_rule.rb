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

class DefaultRegionRule < RegionRule
  validates :name, presence: true, uniqueness: true
end
