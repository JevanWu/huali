class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order
      t.references :product
      t.integer :quantity, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.timestamps
    end

    add_index :line_items, [:order_id],   name: 'index_line_items_on_order_id'
    add_index :line_items, [:product_id], name: 'index_line_items_on_product_id'
  end
end
