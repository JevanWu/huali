require 'spec_helper'

describe OrderDiscountPolicy do

  describe "#apply" do
    let(:coupon_code_record) { create(:coupon, adjustment: '*0.9').coupon_codes.first }

    let(:order) do
      Order.new.tap do |order|
        stub(order).item_total { 200 }
        stub(order).total { 200 }
        stub(order).coupon_code { 'code' }
        stub(order).save!
      end
    end

    let(:order_discount_policy) do
      OrderDiscountPolicy.new(order)
    end

    context "when order has no both adjustment and coupon_code_string" do
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

    context "when order has no adjustment but has a coupon_code_string" do
      before do
        any_instance_of(OrderDiscountPolicy, fetch_coupon: lambda {|_| coupon_code_record })
      end

      context "when the coupon is not usable with the order" do
        it "raise error" do
          stub(coupon_code_record).usable?(order) { false }

          lambda {
            order_discount_policy.apply
          }.should raise_error(ArgumentError)
        end
      end

      it "changes total of order with the coupon's adjustment and record the usage of the coupon" do
        # needs to stub fetch_coupon before policy object is initialized
        mock(coupon_code_record).use!
        mock(order).total = 180
        mock(order).coupon_code_record = coupon_code_record

        order_discount_policy.apply
      end
    end
  end
end
