class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.decimal :item_total
      t.decimal :total
      t.decimal :payment_total
      t.string :state
      t.string :payment_state
      t.string :shipment_state
      t.references :address
      t.datetime :completed_at
      t.references :user
      t.text :special_instructions

      t.timestamps
    end
    add_index :orders, :address_id
    add_index :orders, :user_id
  end
end
