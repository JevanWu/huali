class AddTitleToDiscountEvents < ActiveRecord::Migration
  def change
    add_column :discount_events, :title, :string
  end
end
