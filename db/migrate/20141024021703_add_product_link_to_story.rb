class AddProductLinkToStory < ActiveRecord::Migration
  def change
    add_column :stories, :product_link, :string
  end
end
