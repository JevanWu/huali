# This migration comes from blog_engine (originally 20131121080702)
class CreateBlogCategoriesPosts < ActiveRecord::Migration
  def change
    create_table :blog_categories_posts, id: false do |t|
      t.integer "blog_post_id"
      t.integer "blog_category_id"
    end
  end
end
