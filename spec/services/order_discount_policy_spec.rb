require 'spec_helper'

describe OrderDiscountPolicy do

  describe "#apply" do
    let(:coupon) { Coupon.new(adjustment: '*0.9') }

    let(:order) do
      Order.new.tap do |order|
        stub(order).item_total { 200 }
        stub(order).total { 200 }
        stub(order).coupon_code { 'code' }
      end
    end

    let(:order_discount_policy) do
      OrderDiscountPolicy.new(order)
    end

    context "when order has no both adjustment and coupon_code" do
      it "do not change total of order" do
        order_discount_policy.apply
        order.total.should == 200
      end
    end

    context "when order has adjustment" do
      it "changes total of order with manual adjustment" do
        stub(order).adjustment { '*0.8' }
        mock(order).total = 160

        order_discount_policy.apply
      end
    end

    context "when order has no coupon_code" do
      it "nullify the the old coupon" do
        stub(order).coupon_code { nil }
        order.coupon = coupon
        mock(order).coupon = nil

        order_discount_policy.apply
      end
    end

    context "when order has no adjustment but has a coupon_code" do
      it "changes total of order with the coupon's adjustment and record the usage of order" do
        # needs to stub fetch_coupon before policy object is initialized
        any_instance_of(OrderDiscountPolicy, fetch_coupon: lambda {|_| coupon })
        mock(coupon).use_and_record_usage_if_applied(order)
        mock(order).total = 180

        order_discount_policy.apply
      end
    end
  end
end
