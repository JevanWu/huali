class DropProductPart < ActiveRecord::Migration
  class Asset < ActiveRecord::Base
  end

  def up
    drop_table :product_parts
    Asset.where("viewable_type = 'ProductPart'").delete_all()
  end

  def down
    create_table :product_parts do |t|
      t.string :name_cn, null: false
      t.string :name_en, null: false
      t.text :description
      t.references :product
      t.timestamps
    end
  end
end
