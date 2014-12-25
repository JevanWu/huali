# == Schema Information
#
# Table name: cart_line_items
#
#  cart_id     :integer
#  created_at  :datetime
#  id          :integer          not null, primary key
#  product_id  :integer
#  quantity    :integer
#  total_price :decimal(8, 2)
#  updated_at  :datetime
#
# Indexes
#
#  index_cart_line_items_on_cart_id     (cart_id)
#  index_cart_line_items_on_product_id  (product_id)
#

require 'spec_helper'

describe CartLineItem do
  pending "add some examples to (or delete) #{__FILE__}"
end
