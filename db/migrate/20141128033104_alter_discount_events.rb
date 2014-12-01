class AlterDiscountEvents < ActiveRecord::Migration
  def change
    remove_index :discount_events, :discount_date
  end
end
