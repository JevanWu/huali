class OrderDiscountableValidator < ActiveModel::Validator
  def validate(order)
    if order.coupon_code.present?
      order.line_items.each do |item|
        unless item.product.discountable
          item.errors.add(:base, :product_not_discountable, product_name: item.product.name)
        end
      end

      if order.line_items.any? { |item| !item.product.discountable }
        order.errors.add(:coupon_code, :contains_products_not_discountable)
      end
    end
  end
end
