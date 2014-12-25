class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, index: true
      t.references :coupon_code, index: true
      t.decimal :total_price, precision: 8, scale: 2, default: 0.00, null: false
      t.timestamps
    end
  end
end
