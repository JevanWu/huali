class AddAndRenameProductFieldsForI18n < ActiveRecord::Migration
  def change
    rename_column :products, :name_cn, :name_zh
    rename_column :products, :inspiration, :inspiration_zh
    rename_column :products, :description, :description_zh
    add_column :products, :inspiration_en, :text
    add_column :products, :description_en, :text
  end
end
