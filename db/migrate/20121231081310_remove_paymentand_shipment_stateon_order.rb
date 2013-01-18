class RemovePaymentandShipmentStateonOrder < ActiveRecord::Migration
  def up
    remove_column :orders, :payment_state
    remove_column :orders, :shipment_state
  end

  def down
    add_column :orders, :payment_state, :string
    add_column :orders, :shipment_state, :string
  end
end
