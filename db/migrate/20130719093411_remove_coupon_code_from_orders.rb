class RemoveCouponCodeFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :coupon_code
  end

  def down
    add_column :orders, :coupon_code, :integer
  end
end
