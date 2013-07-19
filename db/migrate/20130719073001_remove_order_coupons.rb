class RemoveOrderCoupons < ActiveRecord::Migration
  def up
    OrderCoupon.unscoped.each do |o|
      o.order.coupon = o.coupon
      o.order.save(validate: false)
    end

    drop_table :order_coupons
  end

  def down
  end
end
