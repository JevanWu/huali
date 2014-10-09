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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sales_chart do
  end
end
