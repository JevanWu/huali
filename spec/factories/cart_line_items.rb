# == Schema Information
#
# Table name: cart_line_items
#
#  cart_id     :integer
#  created_at  :datetime
#  id          :integer          not null, primary key
#  product_id  :integer
#  quantity    :integer          default(0), not null
#  total_price :decimal(8, 2)    default(0.0), not null
#  updated_at  :datetime
#
# Indexes
#
#  index_cart_line_items_on_cart_id     (cart_id)
#  index_cart_line_items_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_line_item do
  end
end
