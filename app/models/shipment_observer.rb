class ShipmentObserver < ActiveRecord::Observer
  def after_ship(shipment, transition)
    Shipment.delay.kuaidi100_poll(shipment.id) if shipment.is_express?
  end
end
