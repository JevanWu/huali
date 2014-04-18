class AddDiscountableToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discountable, :boolean
  end
end
