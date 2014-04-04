class AddUserIdToCouponCode < ActiveRecord::Migration
  def change
    add_reference :coupon_codes, :user, index: true
  end
end
