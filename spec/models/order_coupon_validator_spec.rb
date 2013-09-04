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
        stub(order).coupon_code
      end
    end
    let(:coupon) { Object.new }

    context "when coupon_fetcher returns coupon" do
      context "which was used by the order" do
        before(:each) do
          stub(coupon).used_by_order?(order) { true }

          stub(order_coupon_validator).
            coupon_fetcher { lambda { |_| [coupon] } }
        end

        it "returns with no error" do
          dont_allow(errors).add.with_any_args

          order_coupon_validator.validate(order)
        end
      end

      context "which was not used by the order" do
        before(:each) do
          stub(coupon).used_by_order?(order) { false }
        end

        context "and is not usable" do
          before(:each) do
            stub(coupon).usable? { false }
            stub(order_coupon_validator).
              coupon_fetcher { lambda { |_| [coupon] } }
          end

          it "add :expired_coupon to errors" do
            mock(errors).add :coupon_code, :expired_coupon

            order_coupon_validator.validate(order)
          end
        end

        context "and is usable" do
          before(:each) do
            stub(coupon).usable? { true }
            stub(order_coupon_validator).
              coupon_fetcher { lambda { |_| [coupon] } }
          end

          it "no errors are added" do
            dont_allow(errors).add :coupon_code, :expired_coupon

            order_coupon_validator.validate(order)
          end
        end
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
