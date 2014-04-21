class CreatePrintOrders < ActiveRecord::Migration
  def change
    create_table :print_orders do |t|
      t.references :order
      t.references :print_group, index: true
      t.boolean :order_printed
      t.boolean :card_printed
      t.boolean :shipment_printed

      t.timestamps
    end

    add_index :print_orders, :order_id, unique: true
  end
end
