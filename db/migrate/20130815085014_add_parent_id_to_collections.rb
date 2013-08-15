class AddParentIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :parent_id, :integer
  end
end
