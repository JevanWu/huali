class DiscountManager
  attr_reader :coupon, :order, :discount

  def initialize(order)
    @order = order
    @coupon = order.coupon

    adjust_string = if @order.adjustment.present?
                      @order.adjustment
                    else
                      (@coupon && @coupon.adjustment)
                    end

    @discount = Discount.new(adjust_string)
  end

  def apply_discount(other_discount = nil)
    order.total = (other_discount || discount).calculate(order.item_total)

    coupon.use! if use_coupon? && !other_discount
  end

  private

  def use_coupon?
    order.adjustment.blank? && (order.new_record? || order.changes['coupon_id'])
  end
end
