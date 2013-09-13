class AddPriceConditionFieldOnCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :price_condition, :integer
  end
end
