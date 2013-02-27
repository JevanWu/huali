class AddPublishedEnToProduct < ActiveRecord::Migration
  def change
    rename_column :products, :published, :published_zh
    add_column :products, :published_en, :boolean, default: false
  end
end
