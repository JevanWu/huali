class AddKuaidiResultColumnsToShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :kuaidi100_result, :text
    add_column :shipments, :kuaidi100_status, :integer
  end
end
