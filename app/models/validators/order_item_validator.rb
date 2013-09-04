require_relative 'order_product_base_validator'

class OrderItemValidator < OrderProductBaseValidator
  def validate(order)
    if order.line_items.blank?
      order.errors.add(:base, :blank_products)
    end

    super do |line_item, product|
      unless validate_line_item(line_item, product)
        line_item.errors.add(:base, :product_of_invalid_quantity, product_name: product.name)
        order_error ||= :unavailable_products
      end
      [:base, order_error]
    end
  end

  def validate_line_item(line_item, product)
    line_item.quantity > 0
  end
end
