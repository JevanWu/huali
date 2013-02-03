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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_coupon do
    order nil
    coupon nil
  end
end
