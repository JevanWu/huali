class OrderItemValidator < ActiveModel::Validator
  def validate(order)
    if order.line_items.blank?
      order.errors.add(:base, :blank_products)
      return
    end

    order_valid = true

    order.line_items.each do |line_item|
      order_valid = false unless validate_line_item(line_item)
    end

    order.errors.add(:base, :unavailable_products) unless order_valid
  end

  def validate_line_item(line_item)
    item_valid = true

    unless line_item.published
      line_item.errors.add(:base, :product_unavailable, product_name: line_item.name)
      item_valid = false
    end

    unless line_item.quantity > 0
      line_item.errors.add(:base, :product_of_invalid_quantity, product_name: line_item.name)
      item_valid = false
    end

    unless line_item.sufficient_stock?
      line_item.errors.add(:base, :product_out_of_stock, product_name: line_item.name)
      item_valid = false
    end

    item_valid
  end
end
