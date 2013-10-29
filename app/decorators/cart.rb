class Cart
  attr_accessor :items, :coupon_code

  def initialize(items, coupon_code)
    @items = items
    @coupon_code = coupon_code
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
    if adjustment.present?
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

  delegate :adjustment, to: :coupon, allow_nil: true
end
