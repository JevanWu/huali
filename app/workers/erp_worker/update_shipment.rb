module ErpWorker
  class UpdateShipment
    include Sidekiq::Worker
    sidekiq_options queue: :erp_update_shipment, backtrace: true

    def perform(shipment_id)
      shipment = Shipment.find(shipment_id)
      Erp::Seorder.update_shipment(shipment.order.identifier,
                                   "#{shipment.ship_method}: #{shipment.tracking_num}")
    end
  end
end

