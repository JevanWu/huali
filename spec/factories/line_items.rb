# == Schema Information
#
# Table name: line_items
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer
#  quantity   :integer          not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_line_items_on_order_id    (order_id)
#  index_line_items_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    product
    quantity { Forgery(:basic).number }
    price { product.price }
  end
end
