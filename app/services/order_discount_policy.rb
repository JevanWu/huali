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
    # Order#coupon_code will read order.coupon_code_record as well
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

    apply_limited_promotion
  end

  private

  def apply_limited_promotion
    LimitedPromotion.transaction do
      LimitedPromotion.retrieve_by_products(order.product_ids).each do |promo|
        if promo.usable?
          #new_total = Discount.new(promo.adjustment).calculate(order.total)
          #order.update_attribute(:total, [new_total, 0].max)

          promo.use!
        end
      end
    end
  end

  def apply_adjustment
    total = order.line_items.map do |item|
      if @coupon_code and CouponCode.find_by(code: @coupon_code).products.pluck(:id).include?(item.product_id)
        discount.calculate(item.unit_price) * item.quantity
      else
        item.total_price
      end
    end.inject(:+)

    total = discount.calculate(total)   # for adjustment of manually imported order

    order.update_attribute(:total, total)
  end

  def adjustment
    order.adjustment.presence || (@coupon_code_record && @coupon_code_record.adjustment)
  end

  def discount
    adjustment ? Discount.new(adjustment) : NullDiscount.new(adjustment)
  end

  def use_coupon?
    order.adjustment.blank? && @coupon_code_record &&
      @coupon_code_record != order.coupon_code_record
  end

  def fetch_coupon(coupon_code)
    CouponCode.find_by_code(coupon_code)
  end
end
