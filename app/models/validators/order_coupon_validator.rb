class OrderCouponValidator < ActiveModel::Validator
  class CouponNotFound < StandardError
  end

  def validate(order)
    begin
      coupon = fetch_coupon(order.coupon_code)

      return if coupon.used_by_order?(order)

      unless coupon.usable?(order)
        order.errors.add :coupon_code, :invalid_coupon
      end
    rescue CouponNotFound
      order.errors.add :coupon_code, :non_exist_coupon
    end
  end

  private

  def fetch_coupon(coupon_code)
    coupon = coupon_fetcher.call(code: coupon_code).first

    raise CouponNotFound if coupon.nil?

    coupon
  end

  def coupon_fetcher
    Coupon.public_method(:where)
  end
end
