require 'spec_helper'

describe OrderCouponValidator do
  describe "#validate" do
    let(:order_coupon_validator) { OrderCouponValidator.new({}) }
    let(:errors) { Object.new }
    let(:order) do
      Object.new.tap do |order|
        stub(order).errors { errors }
        stub(order).coupon_code
      end
    end

    context "when coupon_fetcher returns coupon" do
      it "add :expired_coupon to errors  if the coupon is not usable" do
        stub(order_coupon_validator).coupon_fetcher { lambda { |_| [stub!.usable? { false }.subject] } }
        mock(errors).add :coupon_code, :expired_coupon
        order_coupon_validator.validate(order)
      end

      it "no errors are added when the coupon is usable" do
        stub(order_coupon_validator).coupon_fetcher { lambda { |_| [stub!.usable? { true }.subject] } }
        dont_allow(errors).add :coupon_code, :expired_coupon
        order_coupon_validator.validate(order)
      end
    end

    context "when coupon_fetcher Raise Error" do
      it "add :non_exist_coupon to errors" do
        stub(order_coupon_validator).fetch_coupon { raise OrderCouponValidator::CouponNotFound }
        mock(errors).add :coupon_code, :non_exist_coupon
        order_coupon_validator.validate(order)
      end
    end
  end
end
