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

class RegionRule < ActiveRecord::Base
  attr_accessible :area_ids, :city_ids, :province_ids
  belongs_to :product

  serialize :area_ids, Array
  serialize :city_ids, Array
  serialize :province_ids, Array
end
