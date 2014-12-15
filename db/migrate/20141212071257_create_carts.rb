class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, index: true
      t.decimal :total_price, precision: 8, scale: 2, null: false
      t.string :coupon_code
      t.timestamps
    end
  end
end
