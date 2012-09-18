class AddEnNameToCollection < ActiveRecord::Migration
  def change
    rename_column :collections, :name, :name_cn
    change_column :collections, :name_cn, :string, :null => false
    add_column :collections, :name_en, :string, :null => false
  end
end
