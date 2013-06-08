class CreateRegionRules < ActiveRecord::Migration
  def change
    create_table :region_rules do |t|
      t.references :product
      t.string :province_ids
      t.string :city_ids
      t.string :area_ids

      t.timestamps
    end

    add_index :region_rules, :product_id
  end
end
