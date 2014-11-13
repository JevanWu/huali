class InstantDeliveryChargePolicy
  attr_reader :order, :instant_delivery

  def initialize(order, instant_delivery)
    @order = order
    @instant_delivery = instant_delivery
  end

  def apply
    if instant_delivery
      order.create_instant_delivery(delivered_in_minutes: 30, fee: fee_by_address) unless order.instant_delivery
      order.update_column(:total, order.total + order.instant_delivery.fee)
    end
  end

  def fee_by_address
    case order.address.area_id
    when 795 # 黄浦区
      50
    else
      30
    end
  end
end
