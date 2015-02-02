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

class LocalRegionRule < RegionRule
  belongs_to :region_rulable, polymorphic: true

  def self.get_product_ids_by(area_id)
    get_rules_by(area_id).map(&:region_rulable_id)
  end
  def self.get_rules_by(area_id)
    area_id = area_id.to_s
    where(region_rulable_type: "Product").select { |e| e.area_ids.include?(area_id) }
  end
end
