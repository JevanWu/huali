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

require 'spec_helper'

describe RegionRule do
  pending "add some examples to (or delete) #{__FILE__}"
end
