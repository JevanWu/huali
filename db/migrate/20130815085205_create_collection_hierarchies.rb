class CreateCollectionHierarchies < ActiveRecord::Migration
  def change
    create_table :collection_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
      t.integer  :descendant_id, :null => false # ID of the target tag
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" and leaf selects:
    add_index :collection_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true, :name => "collection_anc_desc_udx"

    # For "all ancestors of…" selects,
    add_index :collection_hierarchies, [:descendant_id], :name => "collection_desc_idx"

    Collection.unscoped.each do |collection| # Build hiearchies for old collections
      CollectionHierarchy.create!(ancestor_id: collection.id,
                                  descendant_id: collection.id,
                                  generations: 0)
    end
  end
end
