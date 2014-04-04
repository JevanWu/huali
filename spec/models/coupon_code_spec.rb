# == Schema Information
#
# Table name: coupon_codes
#
#  available_count :integer          default(1)
#  code            :string(255)      not null
#  coupon_id       :integer
#  created_at      :datetime
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  used_count      :integer          default(0)
#  user_id         :integer
#
# Indexes
#
#  index_coupon_codes_on_code       (code) UNIQUE
#  index_coupon_codes_on_coupon_id  (coupon_id)
#  index_coupon_codes_on_user_id    (user_id)
#

require 'spec_helper'

describe CouponCode do
  let(:coupon_code) { create(:coupon_code) }
  let(:order) { Object.new }

  describe "#to_s" do
    it "returns the code" do
      coupon_code.to_s.should eq(coupon_code.code)
    end
  end

  subject { coupon_code }

  describe "#use!" do
    it "reduce available_count by 1" do
      lambda {
        subject.use!
      }.should change { subject.available_count }.by(-1)
    end

    it "increase used_count by 1" do
      lambda {
        subject.use!
      }.should change { subject.used_count }.by(1)
    end
  end

  describe "#usable?" do
    context "when coupon code is manually set expired" do
      before(:each) do
        stub(coupon_code).expired { true }
      end

      it { should_not be_usable }
    end

    context "when coupon code's expired_at is less than current time" do
      before(:each) do
        stub(coupon_code).expires_at { 1.days.ago }
      end

      it { should_not be_usable }
    end

    context "when coupon code's available_count is less than 1" do
      before(:each) do
        stub(coupon_code).available_count { 0 }
      end

      it { should_not be_usable }
    end

    context "when check usibility against a target" do
      context "and checking against the price condition" do
        context "when total price of the target is less than the price condition of coupon code" do
          before(:each) do
            stub(coupon_code).price_condition { 300 }
            stub(order).to_coupon_rule_opts { { total_price: 299, products: [] } }
          end

          it { should_not be_usable(order) }
        end

        context "when the price_condition has not been set" do
          before(:each) do
            stub(coupon_code).price_condition { nil }
            stub(order).to_coupon_rule_opts { { total_price: 301, products: [] } }
          end

          it { should be_usable(order) }
        end
      end

      context "and checking against the products rule" do
        let(:product) { create(:product) }

        before do
          stub(order).to_coupon_rule_opts { { total_price: 301, products: [product] } }
        end

        context "when none of the products in target was not included in the available products of the coupon" do
          let(:coupon) { create(:coupon, :with_products_limitation) }
          let(:coupon_code) { create(:coupon_code, coupon: coupon) }

          it { should_not be_usable(order) }
        end

        context "when one of the products in target was included in the available products of the coupon" do
          let(:coupon) { create(:coupon, :with_products_limitation) }
          let(:coupon_code) { create(:coupon_code, coupon: coupon) }

          before do
            coupon.products << product
          end

          it { should be_usable(order) }
        end

        context "when the available product list is empty" do
          it { should be_usable(order) }
        end
      end
    end
  end
end
