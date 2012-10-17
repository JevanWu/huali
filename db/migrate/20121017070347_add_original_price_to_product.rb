class AddOriginalPriceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :original_price, :decimal
  end
end
