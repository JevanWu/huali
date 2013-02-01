class CreateOrderCoupons < ActiveRecord::Migration
  def change
    create_table :order_coupons do |t|
      t.references :order
      t.references :coupon
    end
    add_index :order_coupons, :order_id
    add_index :order_coupons, :coupon_id
  end
end
