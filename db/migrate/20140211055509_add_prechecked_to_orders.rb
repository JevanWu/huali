class AddPrecheckedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :prechecked, :boolean
  end
end
