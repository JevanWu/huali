class AddTypeAndNameToDateRules < ActiveRecord::Migration
  def change
    add_column :date_rules, :name, :string
    add_column :date_rules, :type, :string
  end
end
