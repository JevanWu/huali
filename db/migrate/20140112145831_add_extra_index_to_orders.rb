class AddExtraIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, [:merchant_order_no, :kind]
  end
end
