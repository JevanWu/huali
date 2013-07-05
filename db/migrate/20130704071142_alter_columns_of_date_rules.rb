class AlterColumnsOfDateRules < ActiveRecord::Migration
  def up
    remove_column :date_rules, :end_date
    add_column :date_rules, :period_length, :string
  end

  def down
    remove_column :date_rules, :period_length
    add_column :date_rules, :end_date, :date
  end
end
