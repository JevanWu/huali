# == Schema Information
#
# Table name: carts
#
#  coupon_code :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  total_price :decimal(8, 2)    not null
#  updated_at  :datetime
#  user_id     :integer
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#

class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_line_items

  validates :user_id, uniqueness: true

  def item
    LineItem.new(product_id: self.product_id,
                 quantity: self.quantity,
                 price: self.price)
  end

end
