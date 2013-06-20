class AddDefaultRegionRuleIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :default_region_rule_id, :integer

    add_index :products, :default_region_rule_id
  end
end
