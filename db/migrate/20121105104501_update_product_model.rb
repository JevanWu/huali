class UpdateProductModel < ActiveRecord::Migration
  def up
    rename_column :products, :intro, :inspiration
    change_column :products, :inspiration, :text

    add_column :products, :name_char, :string
    add_column :products, :related_text, :text

    remove_column :products, :place, :usage, :description2
  end

  def down
    rename_column :products, :inspiration, :intro

    change_column :products, :intro, :string

    remove_column :products, :name_char, :related_text

    add_column :products, :place, :string
    add_column :products, :usage, :string
    add_column :products, :description2, :text
  end
end
