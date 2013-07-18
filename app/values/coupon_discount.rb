class CouponDiscount < Discount
  attr_reader :coupon

  def initialize(coupon)
    @coupon = coupon
    super(coupon.adjustment)
  end
end
