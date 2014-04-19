class OrderDiscountableValidator < ActiveModel::Validator
  def validate(order)
    if order.coupon_code.present?
      order.line_items.each do |item|
        unless item.product.discountable
          order.errors.add(:coupon_code, :product_not_discountable, product_name: item.product.name)
        end
      end
    end
  end
end
