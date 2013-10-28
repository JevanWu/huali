class CreateCouponCodes < ActiveRecord::Migration
  def up
    create_table :coupon_codes do |t|
      t.string :code, null: false
      t.integer :available_count, default: 1
      t.integer :used_count, default: 0
      t.references :coupon, index: true

      t.timestamps
    end
    add_index :coupon_codes, :code, unique: true

    execute "INSERT INTO coupon_codes(coupon_id, code, available_count, used_count) VALUES " <<
    (Coupon.select(:id, :code, :available_count, :used_count).map do |coupon|
      "(#{coupon.id}, '#{coupon.code}', #{coupon.available_count}, #{coupon.used_count})"
    end.join(', '))
  end

  def down
    drop_table :coupon_codes
  end
end
