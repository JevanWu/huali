class GaTrackWorker < Gooa::Client
  include Sidekiq::Worker
  sidekiq_options queue: :analytics, backtrace: true

  class << self
    def order_track(order_id)
      order = Order.find(order_id)
      ga_client_id = order.user.ga_client_id

      transaction_track(ga_client_id, order.identifier, 'hua.li', order.payment_total)

      order.line_items.each do |item|
        add_item_track(ga_client_id, order.identifier, item.name, item.price, item.quantity, item.product_id, item.category_name)
      end
    end
  end
end

