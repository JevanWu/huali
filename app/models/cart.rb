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

  def valid_coupon?
    !! coupon && coupon.usable?(self)
  end
  def coupon
    CouponCode.find_by_code(coupon_code)
  end
  def get_line_items
    self.cart_line_items.map(&:to_line_item)
  end


end
