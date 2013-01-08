class ChangeCostToDecimalInShipMethod < ActiveRecord::Migration
  def up
    change_column :ship_methods, :cost, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def down
    change_column :ship_methods, :cost, :integer
  end
end
