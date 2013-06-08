class CreateDateRules < ActiveRecord::Migration
  def change
    create_table :date_rules do |t|
      t.references :product
      t.date :start_date
      t.date :end_date
      t.string :included_dates
      t.string :excluded_dates
      t.string :excluded_weekdays

      t.timestamps
    end

    add_index :date_rules, :product_id
  end
end
