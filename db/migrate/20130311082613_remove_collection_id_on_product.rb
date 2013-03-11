class RemoveCollectionIdOnProduct < ActiveRecord::Migration
  def up
    remove_column :products, :collection_id
  end

  def down
    add_column :products, :collection_id, :integer
  end
end
