class Discount
  attr_reader :operator, :number

  def initialize(adjustment)
    adjust = adjustment.squeeze(' ').sub('x', '*').sub('%', '/')
    @operator = adjust.first.to_sym
    @number = adjust[1..-1].to_f
  end

  def calculate(amount)
    amount.send(operator, number)
  end

  def self.generate(adjustment, coupon)
    if adjustment.present?
      ManualDiscount.new(adjustment)
    elsif coupon.present?
      CouponDiscount.new(coupon)
    else
      NullDiscount.new
    end
  end

  def ==(other)
    operator == other.operator && number == other.number
  end
end
