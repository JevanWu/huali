class CreateProvCityArea < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :name
      t.integer :post_code
    end

    create_table :cities do |t|
      t.string :name
      t.integer :post_code
      t.integer :parent_post_code #foreign_key
    end

    create_table :areas do |t|
      t.string :name
      t.integer :post_code
      t.integer :parent_post_code #foreign_key
    end

    add_index :provinces, [:post_code], name: 'index_provinces_on_post_code', unique: true
    add_index :cities, [:post_code], name: 'index_cities_on_post_code', unique: true
    add_index :areas, [:post_code], name: 'index_areas_on_post_code', unique: true
  end
end
