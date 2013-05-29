class RemoveColumnsEnOnProductsAndCollections < ActiveRecord::Migration
  def up
    remove_columns :products, :inspiration_en, :description_en, :published_en, :name_char, :cost_price
    rename_column :products, :inspiration_zh, :inspiration
    rename_column :products, :description_zh, :description
    rename_column :products, :published_zh, :published
  end

  def down
    add_column :products, :inspiration_en, :text
    add_column :products, :description_en, :text
    add_column :products, :published_en, :boolean, default: false
    add_column :products, :cost_price, :decimal, precision: 8, scale: 2
    rename_column :products, :inspiration, :inspiration_zh
    rename_column :products, :description, :description_zh
    rename_column :products, :published, :published_zh
  end
end
