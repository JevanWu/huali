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

class RegionRule < ActiveRecord::Base
  serialize :area_ids, Array
  serialize :city_ids, Array
  serialize :province_ids, Array
  arrayify_attrs :area_ids, :city_ids, :province_ids

  def available_area_ids_in_a_city(city_id)
    area_ids_of_one_city(city_id) & area_ids
  end

  def available_city_ids_in_a_prov(prov_id)
    city_ids_of_one_prov(prov_id) & effective_city_ids
  end

  def effective_city_ids
    city_ids | Area.parent_cities(area_ids)
  end

  def effective_prov_ids
    province_ids | City.parent_provinces(effective_city_ids)
  end
  alias :available_prov_ids :effective_prov_ids

  private

  def area_ids_of_one_city(city_id)
    City.find(city_id).areas.map(&:id).map(&:to_s)
  end

  def city_ids_of_one_prov(prov_id)
    Province.find(prov_id).cities.map(&:id).map(&:to_s)
  end

end
