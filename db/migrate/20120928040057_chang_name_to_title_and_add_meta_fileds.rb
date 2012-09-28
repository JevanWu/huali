class ChangNameToTitleAndAddMetaFileds < ActiveRecord::Migration
  def up
    rename_column :pages, :name, :title
    add_column :pages, :meta_keywords, :string
    add_column :pages, :meta_description, :string
  end

  def down
    rename_column :pages, :title, :name
    remove_column :pages, :meta_keywords
    remove_column :pages, :meta_description
  end
end
