# == Schema Information
#
# Table name: order_coupons
#
#  coupon_id :integer
#  id        :integer          not null, primary key
#  order_id  :integer
#
# Indexes
#
#  index_order_coupons_on_coupon_id  (coupon_id)
#  index_order_coupons_on_order_id   (order_id)
#

class OrderCoupon < ActiveRecord::Base
  attr_accessible :coupon_id, :order_id

  belongs_to :order
  belongs_to :coupon
end
