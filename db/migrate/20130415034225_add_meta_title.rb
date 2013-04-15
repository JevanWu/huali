class AddMetaTitle < ActiveRecord::Migration
  def up
		add_column :products, :meta_title, :string
		add_column :collections, :meta_title, :string
		add_column :pages, :meta_title, :string
  end

  def down
	  remove_column :products, :meta_title
	  remove_column :collections, :meta_title
	  remove_column :pages, :meta_title
  end
end