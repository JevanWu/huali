class AlterIndexForDiscountEvents < ActiveRecord::Migration
  def up
    remove_index :discount_events, :start_date
    remove_index :discount_events, :end_date

    add_index :discount_events, [:product_id, :start_date], unique: true
    add_index :discount_events, [:product_id, :end_date], unique: true
  end

  def down
  end
end
