class CreateCartLineItems < ActiveRecord::Migration
  def change
    create_table :cart_line_items do |t|
      t.references :cart, index: true
      t.references :product, index: true
      t.decimal :total_price, precision: 8, scale: 2, default: 0.00, null: false
      t.integer :quantity, default: 0, null: false
      t.timestamps
    end
  end
end
