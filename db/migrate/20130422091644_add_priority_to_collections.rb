class AddPriorityToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :priority, :integer, default: 5
  end
end
