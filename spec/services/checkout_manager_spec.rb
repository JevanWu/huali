require 'spec_helper'

describe CheckoutManager do
  describe ".apply_discount" do
    it "changes total of order" do
      order, discount = Object.new, Object.new
      stub(order).item_total { 200 }
      stub(discount).calculate(order.item_total) { 190 }
      mock(order).total = 190

      CheckoutManager.apply_discount(order, discount)
    end

    context "with a CouponDiscount discount" do
      context "when order is new record" do
        it "changes total of order and use the coupon in the CouponDiscount" do
          order, coupon = Object.new, Object.new
          stub(order).item_total { 200 }
          stub(order).new_record? { true }
          stub(order).coupon { coupon }
          stub(coupon).adjustment { "*0.9" }

          discount = CouponDiscount.new(order.coupon)
          mock(order).total = 180
          mock(order.coupon).use!

          CheckoutManager.apply_discount(order, discount)
        end
      end

      context "when order is not new record and its coupon_id has changed" do
        it "changes total of order and use the coupon in the CouponDiscount" do
          order, coupon = Object.new, Object.new
          stub(order).item_total { 200 }
          stub(order).new_record? { false }
          stub(order).changes { {'coupon_id' => [2, 1] } }
          stub(order).coupon { coupon }
          stub(coupon).adjustment { "*0.9" }

          discount = CouponDiscount.new(order.coupon)
          mock(order).total = 180
          mock(order.coupon).use!

          CheckoutManager.apply_discount(order, discount)
        end
      end
    end
  end
end
