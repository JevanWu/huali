class Cart
  attr_accessor :items, :coupon_code

  def initialize(items, coupon_code, adjustment = nil)
    @items = items
    @coupon_code = coupon_code
    @adjustment = adjustment
  end

  def adjustment
    @adjustment ||= (coupon ? coupon.adjustment : nil)
  end

  def original_total
    items.map(&:total).reduce(:+)
  end

  def item_count
    items.map(&:quantity).reduce(:+)
  end

  def valid_coupon?
    !! coupon && coupon.usable?
  end

  def total
    if adjustment.present?# && valid_coupon?
      Discount.new(adjustment).calculate(original_total)
    else
      original_total
    end
  end

  def discounted?
    total != original_total
  end

  def discount_money
    original_total - total
  end

  def discount_rate
    total / original_total
  end

  private

  def coupon
    CouponCode.find_by_code(coupon_code)
  end
end
