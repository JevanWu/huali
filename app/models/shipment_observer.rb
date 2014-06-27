class ShipmentObserver < ActiveRecord::Observer
  def after_ship(shipment, transition)
    Shipment.delay.kuaidi100_poll(shipment.id, $host || 'localhost') if shipment.is_express?
  end

  def after_save(shipment)
    ErpWorker::UpdateShipment.perform_async(shipment.id)
  end
end
