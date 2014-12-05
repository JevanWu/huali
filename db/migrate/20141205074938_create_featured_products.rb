class CreateFeaturedProducts < ActiveRecord::Migration
  def change
    create_table :featured_products do |t|
      t.text :description
      t.boolean :available, default: true
      t.integer :priority
      t.references :product, index: true
      t.attachment :cover

      t.timestamps
    end
  end
end
