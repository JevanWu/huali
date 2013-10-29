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
    @coupon_code = order.coupon_code
    @coupon_code_record = fetch_coupon(@coupon_code)
  end

  def apply
    if use_coupon?
      unless @coupon_code_record.usable?(order)
        raise ArgumentError, "Coupon code(#{@coupon_code_record}) is not usable with the order"
      end

      @coupon_code_record.use!
      @order.coupon_code_record = @coupon_code_record
    end

    apply_adjustment
  end

  private

  def apply_adjustment
    order.total = discount.calculate(order.item_total)
    order.save!
  end

  def adjustment
    order.adjustment.presence || (@coupon_code_record && @coupon_code_record.adjustment)
  end

  def discount
    adjustment ? Discount.new(adjustment) : NullDiscount.new(adjustment)
  end

  def use_coupon?
    order.adjustment.blank? && @coupon_code_record
  end

  def fetch_coupon(coupon_code)
    CouponCode.find_by_code(coupon_code)
  end
end
