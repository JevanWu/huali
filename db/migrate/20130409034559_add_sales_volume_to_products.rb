class AddSalesVolumeToProducts < ActiveRecord::Migration
  def up
    add_column :products, :sales_volume_totally, :integer, :default => 0
  end

  def down
    remove_column :products, :sales_volume_totally
  end
end
