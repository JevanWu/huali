# This migration comes from blog_engine (originally 20131121075154)
class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :title_en
      t.string :author
      t.text :content
      t.text :excerpt
      t.string :keywords
      t.string :slug
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, :published
  end
end
