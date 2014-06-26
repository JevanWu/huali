module ErpWorker
  class ImportOrder
    include Sidekiq::Worker
    sidekiq_options queue: :import_erp_order, backtrace: true

    def perform(order_id)
      order = Order.find(order_id)

      Erp::OrderImporter.new(order).import or Notify.delay.erp_import_failed(order.identifier)
    end
  end
end
