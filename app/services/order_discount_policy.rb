class OrderDiscountPolicy
  attr_reader :coupon, :order

  def initialize(order)
    @order = order
    @coupon = fetch_coupon(order.coupon_code)
  end

  def apply
    if discount
      order.total = discount.calculate(order.item_total)

      coupon.use_and_record_usage_if_applied(order) if use_coupon?
    end
  end

  private

  def adjustment
    @adjustment ||= if order.adjustment.present?
                      order.adjustment
                    else
                      coupon && coupon.adjustment
                    end
  end

  def discount
    @discount ||= Discount.new(adjustment) if adjustment.present?
  end

  def use_coupon?
    order.adjustment.blank? && coupon && !coupon.used_by_order?(order)
  end

  def fetch_coupon(coupon_code)
    Coupon.find_by_code(coupon_code)
  end
end
