class AddKuaidiApiCodetoShipMethod < ActiveRecord::Migration
  def change
    add_column :ship_methods, :kuaidi_api_code, :string
  end
end
