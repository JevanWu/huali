class CreateSyncOrders < ActiveRecord::Migration
  def change
    create_table :sync_orders do |t|
      t.timestamps
    end
  end
end
