class CreateRegionRules < ActiveRecord::Migration
  def change
    create_table :region_rules do |t|
      t.references :product
      t.text :province_ids
      t.text :city_ids
      t.text :area_ids

      t.timestamps
    end

    add_index :region_rules, :product_id
  end
end
