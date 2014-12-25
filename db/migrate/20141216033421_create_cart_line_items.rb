class CreateCartLineItems < ActiveRecord::Migration
  def change
    create_table :cart_line_items do |t|
      t.references :cart, index: true
      t.references :product, index: true
      t.decimal :total_price, precision: 8, scale: 2
      t.integer :quantity
      t.timestamps
    end
  end
end
