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

require 'spec_helper'

describe OrderCoupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
