class AddShipMethodIdOnOrder < ActiveRecord::Migration
  def change
    add_column :orders, :ship_method_id, :string
  end
end
