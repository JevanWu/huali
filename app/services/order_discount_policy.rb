class NullDiscount
  def initialize(*); end
  def calculate(amount)
    amount 
  end
end

class OrderDiscountPolicy
  attr_reader :order
  private :order

  def initialize(order)
    @order = order
    # FIXME a troublesome design
    # Order#coupon_code will read order.coupon as well
    @coupon_code = order.instance_variable_get(:@coupon_code)
    @coupon = fetch_coupon(order.coupon_code)
  end

  def apply
    apply_adjustment
    @coupon.use_and_record_usage_if_applied(order) if use_coupon?
    clear_coupon(order) if @coupon_code.blank?
  end

  private

  def apply_adjustment
    order.total = discount.calculate(order.item_total)
  end

  def clear_coupon(order)
    order.coupon = nil
  end

  def adjustment
    order.adjustment.presence || (@coupon && @coupon.adjustment)
  end

  def discount
    adjustment ? Discount.new(adjustment) : NullDiscount.new(adjustment)
  end

  def use_coupon?
    order.adjustment.blank? && @coupon
  end

  def fetch_coupon(coupon_code)
    Coupon.find_by_code(coupon_code)
  end
end
