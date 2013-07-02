class AddTypeToRegionRules < ActiveRecord::Migration
  def change
    add_column :region_rules, :name, :string
    add_column :region_rules, :type, :string
  end
end
