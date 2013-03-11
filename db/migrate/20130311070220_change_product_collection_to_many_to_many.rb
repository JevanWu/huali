class Product < ActiveRecord::Base
end
class ChangeProductCollectionToManyToMany < ActiveRecord::Migration
  def up
    create_table(:collections_products, :id => false) do |t|
      t.column :product_id, :integer
      t.column :collection_id, :integer
    end

    add_index(:collections_products, [:product_id, :collection_id], unique: true)

    Product.unscoped.all.each do |product|
      execute <<-SQL
        INSERT INTO collections_products (product_id, collection_id) VALUES (#{product.id}, #{product.collection_id})
      SQL
    end
  end

  def down
    drop_table("collections_products")
  end
end
