class CreateProductParts < ActiveRecord::Migration
  def change
    create_table :product_parts do |t|
      t.string :name_cn, null: false
      t.string :name_en, null: false
      t.text :description
      t.references :product

      t.timestamps
    end
  end
end
