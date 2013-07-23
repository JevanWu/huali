class OrderCouponValidator < ActiveModel::Validator
  def validate(order)
    if order.coupon_code # User placing order with coupon code
      coupon = Coupon.find_by_code(order.coupon_code)

      if coupon
        order.errors.add :coupon_code, :expired_coupon unless coupon.usable?
      else
        order.errors.add :coupon_code, :non_exist_coupon
      end
    elsif order.coupon # Admin editing order coupon
      if order.changes['coupon_id']
        order.errors.add :coupon, :expired_coupon unless order.coupon.usable?
      end
    end
  end
end
