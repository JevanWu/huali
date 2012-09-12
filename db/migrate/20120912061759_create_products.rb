class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      # meta info
      t.string :name_cn, :default => '', :null => false
      t.string :name_en, :default => '', :null => false
      t.text :description

      # SEO related
      t.string :meta_description
      t.string :meta_keywords

      # SKU info
      t.integer :count_on_hand, :default => 0, :null => false
      t.decimal :cost_price, :precision => 8, :scale => 2
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :height, :precision => 8, :scale => 2
      t.decimal :width, :precision => 8, :scale => 2
      t.decimal :depth, :precision => 8, :scale => 2

      t.datetime :available_on
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :products, [:name_en], :name => 'index_products_on_name_en'
    add_index :products, [:available_on], :name => 'index_products_on_available_on'
    add_index :products, [:deleted_at], :name => 'index_products_on_deleted_at'
  end
end
