class AddCountToCoupon < ActiveRecord::Migration
  def up
    rename_column :coupons, :used, :expired
    add_column :coupons, :count, :integer, default: 1, null: false
    change_column :coupons, :expires_at, :date, null: false
  end

  def down
    rename_column :coupons, :expired, :used
    remove_column :coupons, :count
    change_column :coupons, :expires_at, :date, null: true
  end
end
