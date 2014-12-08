class CreateDiscountEvents < ActiveRecord::Migration
  def change
    create_table :discount_events do |t|
      t.references :product, index: true
      t.date :discount_date
      t.decimal :original_price, precision: 8, scale: 2
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end

    add_index :discount_events, [:product_id, :discount_date]
    add_index :discount_events, :discount_date, unique: true
  end
end
