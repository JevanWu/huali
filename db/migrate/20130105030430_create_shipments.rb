class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :identifier
      t.string :tracking_num
      t.string :state
      t.text :note
      t.integer :cost
      t.references :address
      t.references :ship_method
      t.references :order

      t.timestamps
    end

    add_index :shipments, :ship_method_id
    add_index :shipments, :order_id
    add_index :shipments, :identifier
    add_index :shipments, :tracking_num
  end
end
