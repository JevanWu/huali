require 'spec_helper'

describe OrderDiscountPolicy do

  describe "#apply" do
    let(:order) do
      Object.new.tap do |order|
        stub(order).item_total { 200 }
        stub(order).coupon_code { nil }
        stub(order).adjustment { nil }
        stub(order).coupon = anything
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

    context "when order has no coupon_code" do
      before(:each) do
        stub(order).adjustment
        stub(order).coupon_code { nil }
      end

      it "nullify the the old coupon" do
        mock(order).coupon = nil

        order_discount_policy.apply
      end
    end


    context "when order has no adjustment but has a coupon_code" do
      before(:each) do
        stub(order).adjustment { nil }
        stub(order).coupon_code { 'code' }
        stub(coupon).adjustment { '*0.9' }

        stub(order).total = numeric
        stub(Coupon).find_by_code(order.coupon_code) { coupon }
      end

      it "changes total of order with the coupon" do
        stub(coupon).use_and_record_usage_if_applied(order)

        mock(order).total = 180

        order_discount_policy.apply
      end

      it "record usage of the order" do
        mock(coupon).use_and_record_usage_if_applied(order)

        order_discount_policy.apply
      end
    end

    context "when order has no both adjustment and coupon_code" do
      before(:each) do
        stub(order).adjustment { nil }
        stub(order).coupon_code { nil }
      end

      it "do not change total of order" do
        dont_allow(order).total = anything

        order_discount_policy.apply
      end
    end

  end
end
