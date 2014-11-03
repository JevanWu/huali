class InstantDeliveryChargePolicy
  attr_reader :order, :instant_delivery

  def initialize(order, instant_delivery)
    @order = order
    @instant_delivery = instant_delivery
  end

  def apply
    if instant_delivery
      order.create_instant_delivery(delivered_in_minutes: 30, fee: 100) unless order.instant_delivery
      order.update_column(:total, order.total + order.instant_delivery.fee)
    end
  end
end
