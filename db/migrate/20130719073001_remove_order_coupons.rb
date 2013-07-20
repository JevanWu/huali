class RemoveOrderCoupons < ActiveRecord::Migration
  class OrderCoupon < ActiveRecord::Base
    belongs_to :order
    belongs_to :coupon
  end

  def up
    begin
      OrderCoupon.unscoped.each do |o|
        if o.order && o.coupon # Ensure that no orphan records
          ActiveRecord::Base.connection.
            execute("UPDATE orders SET coupon_id = #{o.coupon_id} WHERE id = #{o.order.id}")
        end
      end
    rescue Exception => e
      puts e
    end

    drop_table :order_coupons
  end

  def down
  end
end
