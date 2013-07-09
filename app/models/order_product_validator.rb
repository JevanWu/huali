class OrderProductValidator < ActiveModel::Validator
  def validate(order)


    if order.line_items.blank?
      order.errors.add(:base, :blank_products)
      return
    end

    order_valid = true

    order.line_items.each do |line_item|
      product = Product.find(line_item.product_id)

      unless product.published
        product.errors.add(:base, :unavailable_product)

        line_item.errors.add(:product, :unavailable_product)

        order_valid && order_valid = false
      end

      unless line_item.quantity > 0
        line_item.errors.add(:product, :invalid_quantity)

        order_valid && order_valid = false
      end
    end

    unless order_valid
      order.errors.add(:base, :unavailable_products)
    end
  end
end
