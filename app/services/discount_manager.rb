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
    order.adjustment.blank? && (new_order_with_coupon? || coupon_changed?)
  end

  def new_order_with_coupon?
    order.new_record? && order.coupon
  end

  def coupon_changed?
    order.persisted? && order.changes['coupon_id']
  end
end
