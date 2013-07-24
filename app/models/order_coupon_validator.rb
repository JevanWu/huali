class OrderCouponValidator < ActiveModel::Validator
  def validate(order)
    begin
      coupon = fetch_coupon(order.coupon_code)
      if not coupon.usable?
        order.errors.add :coupon_code, :expired_coupon 
      end
    rescue ActiveRecord::RecordNotFound
      order.errors.add :coupon_code, :non_exist_coupon
    end
  end

  private

  def fetch_coupon(coupon_code)
    coupon = coupon_fetcher.call(coupon_code)
  end

  def coupon_fetcher
    Coupon.public_method(:find_by_code!)
  end
end
