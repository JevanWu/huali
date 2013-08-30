class OrderProductAvailabilityValidator < OrderProductValidatorBase
  def validate(order)
    order_valid = true

    super do |line_item, product|
      order_valid = false unless validate_line_item(line_item, product)
    end

    order.errors.add(:base, :unavailable_products) unless order_valid
  end

  private

  def validate_line_item(line_item, product)
    item_valid = true

    unless product.published
      line_item.errors.add(:base, :product_unavailable, product_name: product.name)
      item_valid = false
    end

    unless sufficient_stock?(line_item, product)
      line_item.errors.add(:base, :product_out_of_stock, product_name: product.name, count_on_hand: product.count_on_hand)
      item_valid = false
    end

    item_valid
  end

  def sufficient_stock?(line_item, product)
    product.count_on_hand >= line_item.quantity
  end
end

