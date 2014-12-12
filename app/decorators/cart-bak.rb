class Cart
  attr_accessor :items, :coupon_code

  def initialize(items, coupon_code, adjustment = nil)
    @items = items
    @coupon_code = coupon_code
    @adjustment = adjustment
  end

  def adjustment
    @adjustment ||= (valid_coupon? ? coupon.adjustment : nil)
  end

  def original_total
    items.map(&:total).reduce(:+)
  end

  def item_count
    items.map(&:quantity).reduce(:+)
  end

  def valid_coupon?
    !! coupon && coupon.usable?(self)
  end

  def total
    @total = if adjustment.present?# && valid_coupon?
               [Discount.new(adjustment).calculate(original_total), 0].max
             else
               original_total
             end

    if limited_promotion_today && limited_promotion_today.usable?
      @total = [Discount.new(limited_promotion_today.adjustment).calculate(@total), 0].max
    end

    @total
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

  def to_coupon_rule_opts
    { total_price: original_total, products: products }
  end

  def limited_promotion_today
    products.each do |p|
      return p.limited_promotion_today if p.limited_promotion_today
    end

    nil
  end

  private

  def products
    items.map(&:product)
  end

  def coupon
    CouponCode.find_by_code(coupon_code)
  end
end
