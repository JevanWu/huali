class RemoveCostOnShipmentAndMethod < ActiveRecord::Migration
  def up
    remove_column :shipments, :cost
    remove_column :ship_methods, :cost
  end

  def down
    add_column :shipments, :cost, :integer
    add_column :ship_methods, :cost, :integer
  end
end
