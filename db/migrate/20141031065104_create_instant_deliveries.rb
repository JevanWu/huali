class CreateInstantDeliveries < ActiveRecord::Migration
  def change
    create_table :instant_deliveries do |t|
      t.integer :order_id
      t.decimal :fee, precision: 8, scale: 2, default: 0.0, null: false
      t.integer :delivered_in_minutes, null: false
      t.datetime :shipped_at

      t.timestamps
    end
  end
end
