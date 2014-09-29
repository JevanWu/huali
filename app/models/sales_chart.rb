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

class SalesChart < ActiveRecord::Base
  belongs_to :product
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :product, presence: true, uniqueness: true
end
