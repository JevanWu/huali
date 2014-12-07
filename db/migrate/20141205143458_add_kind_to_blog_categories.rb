class AddKindToBlogCategories < ActiveRecord::Migration
  def change
    add_column :blog_categories, :kind, :string
  end
end
