class OrderItemValidator < OrderProductBaseValidator
  def validate(order)
    if order.line_items.blank?
      order.errors.add(:base, :blank_products)
      return
    end

    super do |line_item, product|
      validate_line_item(line_item, product)
    end
  end

  def validate_line_item(line_item, product)
    unless line_item.quantity > 0
      line_item.errors.add(:base, :product_of_invalid_quantity, product_name: product.name)
    end
  end
end
