class AddLastOrderToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :last_order, :string
  end
end
