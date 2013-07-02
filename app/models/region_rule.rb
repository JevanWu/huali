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

class RegionRule < ActiveRecord::Base
  attr_accessible :name, :area_ids, :city_ids, :province_ids

  serialize :area_ids, Array
  serialize :city_ids, Array
  serialize :province_ids, Array

  def available_areas_of_city(city_id)
    Area.joins(:city).where("cities.id = ?", city_id).where("areas.id in (?)", area_ids).all
  end

  def available_cities_of_province(province_id)
    available_city_ids = (Area.parent_cities(area_ids) + city_ids).uniq

    City.joins(:province).where("provinces.id = ?", province_id).
      where("cities.id in (?)", available_city_ids).all
  end

  def available_provinces
    available_city_ids = (Area.parent_cities(area_ids) + city_ids).uniq
    available_province_ids = (City.parent_provinces(available_city_ids) + province_ids).uniq

    Province.find_all_by_id(available_province_ids.to_a)
  end
end
