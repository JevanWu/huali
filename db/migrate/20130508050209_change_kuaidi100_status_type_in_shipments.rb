class ChangeKuaidi100StatusTypeInShipments < ActiveRecord::Migration
  def change
    change_column :shipments, :kuaidi100_status, :string
  end
end
