class CreateSyncOrders < ActiveRecord::Migration
  def change
    create_table :sync_orders do |t|
      t.references :administrator, index: true
      t.references :order, index: true
      t.string :kind
      t.string :merchant_order_no
      t.timestamps
    end
  end
end
