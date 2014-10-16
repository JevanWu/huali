# == Schema Information
#
# Table name: sales_charts
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  position   :integer
#  product_id :integer
#  updated_at :datetime
#
# Indexes
#
#  index_sales_charts_on_product_id  (product_id)
#

require 'spec_helper'

describe SalesChart do
  pending "add some examples to (or delete) #{__FILE__}"
end
