class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.decimal :item_total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :payment_total, :precision => 8, :scale => 2, :default => 0.0
      t.string :state
      t.string :payment_state
      t.string :shipment_state
      t.text :special_instructions
      t.references :address
      t.references :user

      t.datetime :completed_at
      t.timestamps
    end

    add_index :orders, [:number], :name => 'index_orders_on_number'
  end
end
