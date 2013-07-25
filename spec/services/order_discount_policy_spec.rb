require 'spec_helper'

describe OrderDiscountPolicy do

  describe "#apply" do
    let(:order) do
      Object.new.tap do |order|
        stub(order).item_total { 200 }
        stub(order).coupon_code { nil }
        stub(order).adjustment { nil }
      end
    end
    let(:coupon) { Object.new }

    let(:order_discount_policy) do
      OrderDiscountPolicy.new(order)
    end

    context "when order has adjustment" do
      it "changes total of order with manual adjustment" do
        stub(order).adjustment { '*0.8' }
        mock(order).total = 160

        order_discount_policy.apply
      end
    end

    context "when order has no adjustment but has a coupon_code" do
      before(:each) do
        stub(order).adjustment { nil }
        stub(order).coupon_code { 'code' }
        stub(coupon).adjustment { '*0.9' }

        stub(order).total = numeric
        stub(coupon).used_by_order?(order) { true }
        stub(Coupon).find_by_code(order.coupon_code) { coupon }
      end

      it "changes total of order with the coupon" do
        mock(order).total = 180

        order_discount_policy.apply
      end

      context "which was used already" do
        before(:each) do
          stub(coupon).used_by_order?(order) { true }
        end

        it "do not record usage of the order" do
          dont_allow(coupon).use_and_record_usage_if_applied(order)

          order_discount_policy.apply
        end
      end

      context "which was not used" do
        before(:each) do
          stub(coupon).used_by_order?(order) { false }
        end

        it "record usage of the order" do
          mock(coupon).use_and_record_usage_if_applied(order)

          order_discount_policy.apply
        end
      end
    end

    context "when order has no both adjustment and coupon_code" do
      it "do not change total of order" do
        stub(order).adjustment { nil }
        stub(order).coupon_code { nil }

        dont_allow(order).total = anything

        order_discount_policy.apply
      end
    end

  end
end
