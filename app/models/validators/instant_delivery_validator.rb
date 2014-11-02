class InstantDeliveryValidator < ActiveModel::Validator
  def validate(order)
    if order.instant_delivery
      if InstantDelivery.used_count_today >= 24
        order.errors.add(:instant_delivery, :instant_delivery_not_available)
      end
    end
  end
end

