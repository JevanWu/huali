class CheckoutManager
  def self.apply_discount(order, discount)
    order.total = discount.calculate(order.item_total)

    if discount.is_a?(CouponDiscount)
      discount.coupon.use! if order.new_record? || order.changes['coupon_id']
    end
  end
end
