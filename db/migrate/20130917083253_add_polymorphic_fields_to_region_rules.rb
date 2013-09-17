class AddPolymorphicFieldsToRegionRules < ActiveRecord::Migration
  def change
    rename_column :region_rules, :product_id, :region_rulable_id
    add_column :region_rules, :region_rulable_type, :string

    execute %(UPDATE region_rules SET region_rulable_type = 'Product' WHERE region_rulable_id IS NOT NULL)
  end
end
