class DidiPassengerReceiveCouponService
  def self.receive_coupon_code(didi_passenger, coupon)
    coupon_code = coupon.generate_coupon_code

    raise ArgumentError, "Invalid coupon" unless coupon_code

    didi_passenger.coupon_code = coupon_code
    didi_passenger.save

    Sms.delay.didi_passenger_coupon(didi_passenger.id)
  end
end
