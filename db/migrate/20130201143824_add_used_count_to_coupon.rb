class AddUsedCountToCoupon < ActiveRecord::Migration
  def change
    rename_column :coupons, :count, :available_count
    add_column :coupons, :used_count, :integer, default: 0
  end
end
