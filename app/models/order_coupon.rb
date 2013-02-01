class OrderCoupon < ActiveRecord::Base
  attr_accessible :coupon_id, :order_id

  belongs_to :order
  belongs_to :coupon
end
