class OrderRefundService
  def self.accept_refund(order, refund)
    raise ArgumentError, "Invalid order state: #{order.state}" if order.state != 'wait_refund'
    raise ArgumentError, "Trying to accept a refund that is rejected" if refund.state == 'rejected'

    ActiveRecord::Base.transaction do
      refund.accept
      order.refund
    end
  end

  def self.reject_refund(order, refund)
    ActiveRecord::Base.transaction do
      refund.reject

      unless order.state == 'completed'
        order.update_column(:state, order.has_shipped_shipment? ? 'wait_confirm' : 'wait_ship')
      end
    end
  end
end
