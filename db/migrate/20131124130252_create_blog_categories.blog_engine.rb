# This migration comes from blog_engine (originally 20131120214030)
class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.string :name_en
      t.text :description
      t.integer :position
      t.string :slug
      t.string :keywords
      t.integer :parent_id
      t.boolean :available

      t.timestamps
    end

    add_index :blog_categories, :slug, unique: true
  end
end
