class OrderCouponValidator < ActiveModel::Validator
  class CouponNotFound < StandardError
  end

  def validate(order)
    begin
      return if order.coupon_code.blank?

      coupon = fetch_coupon(order.coupon_code)

      unless coupon.usable?(order)
        order.errors.add :coupon_code, :invalid_coupon
      end
    rescue CouponNotFound
      order.errors.add :coupon_code, :non_exist_coupon
    end
  end

  private

  def fetch_coupon(coupon_code)
    coupon_code_record = coupon_fetcher.call(code: coupon_code).first

    raise CouponNotFound if coupon_code_record.nil?

    coupon_code_record
  end

  def coupon_fetcher
    CouponCode.public_method(:where)
  end
end
