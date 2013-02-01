class OrderCoupon < ActiveRecord::Base
  belongs_to :order
  belongs_to :coupon
end
