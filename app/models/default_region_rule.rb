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

class DefaultRegionRule < RegionRule
  validates :name, presence: true, uniqueness: true

  def self.get_ids_by(city_id)
    arr = []
    self.find_each { |e| arr << e.id if e.area_ids.include?(city_id) }
    arr
  end
end
