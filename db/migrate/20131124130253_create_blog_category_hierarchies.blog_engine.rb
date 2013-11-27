# This migration comes from blog_engine (originally 20131121040731)
class CreateBlogCategoryHierarchies < ActiveRecord::Migration
  def change
    create_table :blog_category_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
      t.integer  :descendant_id, :null => false # ID of the target tag
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" and leaf selects:
    add_index :blog_category_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true, :name => "blog_category_anc_desc_udx"

    # For "all ancestors of…" selects,
    add_index :blog_category_hierarchies, [:descendant_id], :name => "blog_category_desc_idx"
  end
end
