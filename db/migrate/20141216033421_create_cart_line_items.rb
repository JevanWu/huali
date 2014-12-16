class CreateCartLineItems < ActiveRecord::Migration
  def change
    create_table :cart_line_items do |t|
      t.references :cart, index: true
      t.references :product, index: true
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
