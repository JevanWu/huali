class OrderItemValidator < ActiveModel::Validator
  include OrderProductValidationHelper

  def validate(order)
    if order.line_items.blank?
      order.errors.add(:base, :blank_products)
      return
    end

    order.line_items.each do |line_item|
      validate_line_item(line_item)
    end
  end

  def validate_line_item(line_item)
    product = fetch_product(line_item)

    unless line_item.quantity > 0
      line_item.errors.add(:base, :product_of_invalid_quantity, product_name: product.name)
    end
  end
end
