class RemovePriceonItem < ActiveRecord::Migration
  def up
    remove_column :line_items, :price
  end

  def down
    add_column :line_items, :price, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
