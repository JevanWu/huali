# == Schema Information
#
# Table name: cart_line_items
#
#  cart_id    :integer
#  created_at :datetime
#  id         :integer          not null, primary key
#  price      :decimal(8, 2)    not null
#  product_id :integer
#  quantity   :integer          not null
#  updated_at :datetime
#
# Indexes
#
#  index_cart_line_items_on_cart_id     (cart_id)
#  index_cart_line_items_on_product_id  (product_id)
#

class CartLineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  def to_line_item
    LineItem.new(product_id: self.product_id,
                 quantity: self.quantity,
                 price: self.price)
  end
  def original_price
    self.product.original_price_value
  end
end
