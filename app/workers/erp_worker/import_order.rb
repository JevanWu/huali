module ErpWorker
  class ImportOrder
    include Sidekiq::Worker
    sidekiq_options queue: :erp_import_order, backtrace: true

    def perform(order_id)
      order = Order.find(order_id)
      Erp::OrderImporter.new(order).import
    end
  end
end
