class AddDefaultDateRuleIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :default_date_rule_id, :integer

    add_index :products, :default_date_rule_id
  end
end
