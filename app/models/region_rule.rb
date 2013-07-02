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
end
