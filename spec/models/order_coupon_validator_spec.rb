require 'spec_helper'

describe OrderCouponValidator do
  describe "#validate" do
    let(:order) do
      order = Object.new

      error_hash = {}
      def error_hash.add(key, value)
        self[key] ||= []
        self[key] << value
      end

      stub(order).errors { error_hash }
      order
    end

    context "with order that has a coupon_code" do
      before(:each) do
        stub(order).coupon_code { 'test_code' }
      end

      context "and the coupon code exists" do
        it "add errors to order if the coupon code is not usable" do
          stub(Coupon).find_by_code('test_code') { stub!.usable? { false }.subject }

          OrderCouponValidator.new({}).validate(order)

          order.errors[:coupon_code].should include(:expired_coupon)
        end
      end

      context "but the coupon code does not exist" do
        it "add errors to order, indicating non-exists coupon" do
          stub(Coupon).find_by_code('test_code') { nil }

          OrderCouponValidator.new({}).validate(order)

          order.errors[:coupon_code].should include(:non_exist_coupon)
        end
      end
    end

    context "with order has no coupon code but a persisted coupon" do
      before(:each) do
        stub(order).coupon_code { nil }
      end

      context "which has changed" do
        before(:each) do
          stub(order).changes { { 'coupon_id' => [1, 2] } }
        end

        it "add errors to the order if the coupon is not usable" do
          stub(order).coupon { stub!.usable? { false }.subject }

          OrderCouponValidator.new({}).validate(order)

          order.errors[:coupon].should include(:expired_coupon)
        end
      end
    end
  end
end
