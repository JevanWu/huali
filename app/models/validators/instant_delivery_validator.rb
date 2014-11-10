require_relative 'order_product_base_validator'

class InstantDeliveryValidator < OrderProductBaseValidator
  def validate(order)
    if order.instant_delivery
      if !InstantDeliveryCheckService.new(order.address.city_id, order.address.address).check || InstantDelivery.used_count_today >= 24
        order.errors.add(:instant_delivery, :instant_delivery_not_available)
      end

      order_error = nil
      super do |line_item, product|
        unless validate_line_item(line_item, product)
          line_item.errors.add(:base, :product_unavailable_in_instant_delivery, product_name: product.name)
          order_error ||= :unavailable_products
        end

        [:base, order_error]
      end
    end
  end

  def validate_line_item(line_item, product)
    product.product_type == 'preserved_flower'
  end
end

