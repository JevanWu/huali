class OrderCouponValidator < ActiveModel::Validator
  class CouponNotFound < StandardError
  end

  def validate(order)
    begin
      coupon = fetch_coupon(order.coupon_code_string)

      unless coupon.usable?(order)
        order.errors.add :coupon_code_string, :invalid_coupon
      end
    rescue CouponNotFound
      order.errors.add :coupon_code_string, :non_exist_coupon
    end
  end

  private

  def fetch_coupon(coupon_code_string)
    coupon_code = coupon_fetcher.call(code: coupon_code_string).first

    raise CouponNotFound if coupon_code.nil?

    coupon_code
  end

  def coupon_fetcher
    CouponCode.public_method(:where)
  end
end
