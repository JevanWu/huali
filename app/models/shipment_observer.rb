class ShipmentObserver < ActiveRecord::Observer
  def after_accept(shipment, transition)
    Shipment.kuaidi100_poll(shipment.id) if shipment.is_express?
  end
end
