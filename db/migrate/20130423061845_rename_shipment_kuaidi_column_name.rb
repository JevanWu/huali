class RenameShipmentKuaidiColumnName < ActiveRecord::Migration
  def up
    rename_column :ship_methods, :kuaidi_com_code, :kuaidi_query_code
  end

  def down
    rename_column :ship_methods, :kuaidi_query_code, :kuaidi_com_code
  end
end
