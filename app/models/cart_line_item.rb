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

  delegate :discount?, :sold_total, :img, :name, :name_en, :height, :width,
    :depth, :category_name, :published, :product_type, :product_type_text, :sku_id, to: :product

  def to_line_item
    LineItem.new(product_id: self.product_id,
                 quantity: self.quantity,
                 price: self.price)
  end
  def discounted?
    total_price != original_total_price
  end
  def total_price
    price * quantity
  end
  def original_price
    product.original_price_value
  end
  def original_total_price
    self.product.original_price_value * quantity
  end
  def on_stock?
    product.count_on_hand > 0
  end
end
