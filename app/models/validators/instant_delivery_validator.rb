class InstantDeliveryValidator < ActiveModel::Validator
  def validate(order)
    if order.instant_delivery
      if InstantDelivery.used_count_today >= Setting.max_instant_delivery || 24
        order.errors.add(:base, :instant_delivery_not_available)
      end
    end
  end
end

