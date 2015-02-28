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
  has_many :products

  def self.get_product_ids_by(area_id)
    get_rules_by(area_id).map(&:product_ids).flatten.select do |p_id|
      Product.find(p_id).local_region_rule.nil?  # because local_region_rule can rewrite default_region_rule
    end
  end
  def self.get_rules_by(area_id)
    area_id = area_id.to_s
    arr = []
    find_each { |r|  arr << r if r.area_ids.include?(area_id) }
    arr
  end

end
