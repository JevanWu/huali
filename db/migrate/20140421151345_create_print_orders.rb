class CreatePrintOrders < ActiveRecord::Migration
  def change
    create_table :print_orders do |t|
      t.references :order
      t.references :print_group, index: true
      t.boolean :order_printed, default: false
      t.boolean :card_printed, default: false
      t.boolean :shipment_printed, default: false

      t.timestamps
    end

    add_index :print_orders, :order_id, unique: true
  end
end
