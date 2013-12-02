class CreateCouponsProducts < ActiveRecord::Migration
  def change
    create_table :coupons_products, id: false do |t|
      t.integer :coupon_id
      t.integer :product_id
    end

    add_index :coupons_products, [:coupon_id, :product_id], unique: true
  end
end
