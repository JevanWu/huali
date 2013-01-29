class AddMetaKeywordsAndDescriptionToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :meta_keywords, :string
    add_column :collections, :meta_description, :string
  end
end
