class AddKuaidiComCodetoShipMethod < ActiveRecord::Migration
  def change
    add_column :ship_methods, :kuaidi_com_code, :string
  end
end
