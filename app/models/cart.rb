# == Schema Information
#
# Table name: carts
#
#  coupon_code :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  price       :decimal(8, 2)    not null
#  product_id  :integer
#  quantity    :integer          not null
#  updated_at  :datetime
#  user_id     :integer
#
# Indexes
#
#  index_carts_on_product_id  (product_id)
#  index_carts_on_user_id     (user_id)
#

class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  def item
    LineItem.new(product_id: self.product_id,
                 quantity: self.quantity,
                 price: self.price)
  end

end
