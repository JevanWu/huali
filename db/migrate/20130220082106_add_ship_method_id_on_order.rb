class Order < ActiveRecord::Base
end

class Shipment < ActiveRecord::Base
end

class AddShipMethodIdOnOrder < ActiveRecord::Migration
  def up
    add_column :orders, :ship_method_id, :string

    Order.find_each do |o|
      if o.shipment
        o.ship_method = o.shipment.ship_method
        o.save
      end
    end
  end

  def down
    remove_column :orders, :ship_method_id
  end
end
