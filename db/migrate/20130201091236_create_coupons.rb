class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.string :adjustment, null: false
      t.boolean :used, null: false, default: false
      t.datetime :expires_at
      t.timestamps
    end
    add_index :coupons, :code, unique: true, name: 'coupons_on_code'
  end
end
