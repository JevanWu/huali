class RemoveAvailableColumnOnProduct < ActiveRecord::Migration
  def up
    remove_column :products, :available
  end

  def down
    add_column :products, :available, :boolean, default: true
  end
end
