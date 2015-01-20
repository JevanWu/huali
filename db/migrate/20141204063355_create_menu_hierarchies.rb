class CreateMenuHierarchies < ActiveRecord::Migration
  def change
    create_table :menu_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... menu
      t.integer  :descendant_id, :null => false # ID of the target menu
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    add_index :menu_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true, :name => "menu_anc_desc_udx"

    add_index :menu_hierarchies, [:descendant_id],
      :name => "menu_desc_idx"
  end
end
