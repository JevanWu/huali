class AddNoteToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :note, :string
  end
end
