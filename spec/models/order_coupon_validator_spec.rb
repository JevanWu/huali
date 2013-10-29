require 'spec_helper_lite'
require 'active_model'
require 'order_coupon_validator'

describe OrderCouponValidator do
  describe "#validate" do
    let(:order_coupon_validator) { OrderCouponValidator.new({}) }
    let(:errors) { Object.new }
    let(:order) do
      Object.new.tap do |order|
        stub(order).errors { errors }
        stub(order).coupon_code_string
      end
    end
    let(:coupon_code) { Object.new }

    before(:each) do
      stub(order_coupon_validator).
        coupon_fetcher { lambda { |_| [coupon_code] } }
    end

    context "when coupon code is not usable" do
      it "add :invalid_coupon to errors" do
        stub(coupon_code).usable? { false }

        mock(errors).add :coupon_code_string, :invalid_coupon

        order_coupon_validator.validate(order)
      end
    end

    context "when coupon code is usable" do
      it "no errors are added" do
        stub(coupon_code).usable? { true }

        dont_allow(errors).add :coupon_code_string, :invalid_coupon

        order_coupon_validator.validate(order)
      end
    end

    context "when coupon_fetcher Raise Error" do
      it "add :non_exist_coupon to errors" do
        stub(order_coupon_validator).fetch_coupon { raise OrderCouponValidator::CouponNotFound }

        mock(errors).add :coupon_code_string, :non_exist_coupon

        order_coupon_validator.validate(order)
      end
    end
  end
end
