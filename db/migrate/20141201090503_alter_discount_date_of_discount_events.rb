class AlterDiscountDateOfDiscountEvents < ActiveRecord::Migration
  def up
    add_column :discount_events, :start_date, :date
    add_column :discount_events, :end_date, :date
    remove_column :discount_events, :discount_date

    add_index :discount_events, :start_date, unique: true
    add_index :discount_events, :end_date, unique: true
  end

  def down
    add_column :discount_events, :discount_date, :date

    remove_index :discount_events, :start_date
    remove_index :discount_events, :end_date
    remove_column :discount_events, :start_date
    remove_column :discount_events, :end_date
  end
end
