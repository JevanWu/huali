class RenameVolumnTotallyToSoldVolumn < ActiveRecord::Migration
  def change
    rename_column :products, :sales_volume_totally, :sold_total
  end
end
