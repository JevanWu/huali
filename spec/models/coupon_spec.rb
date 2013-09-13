# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  available_count :integer          default(1), not null
#  code            :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  note            :string(255)
#  updated_at      :datetime         not null
#  used_count      :integer          default(0)
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

require 'spec_helper'

describe Coupon do
  let(:coupon) { create(:coupon) }
  let(:order) { Object.new }

  specify { coupon.to_s.should eq(coupon.code) }

  subject { coupon }

  context "when coupon is set expired" do
    before(:each) do
      stub(coupon).expired { true }
    end

    it { should_not be_usable }
  end

  context "when coupon's expired_at is less than current time" do
    before(:each) do
      stub(coupon).expires_at { 1.days.ago }
    end

    it { should_not be_usable }
  end

  context "when coupon's available_count is less than 1" do
    before(:each) do
      stub(coupon).available_count { 0 }
    end

    it { should_not be_usable }
  end

  context "when order's total price is less than coupon's price condition" do
    before(:each) do
      stub(coupon).price_condition { 300 }
      stub(order).total { 301 }
    end

    it { should_not be_usable(order) }
  end

  describe "#used_by_order?" do
    context "when the order has no coupon" do
      before(:each) do
        stub(order).coupon { nil }
      end

      it { should_not be_used_by_order(order) }
    end

    context "when the order has a coupon" do
      context "which equals to itself" do
        before(:each) do
          stub(order).coupon { coupon }
        end

        it { should be_used_by_order(order) }
      end

      context "which differ from itself" do
        before(:each) do
          stub(order).coupon { create(:coupon) }
        end

        it { should_not be_used_by_order(order) }
      end
    end
  end

  describe "#use_and_record_usage_if_applied" do
    context "when coupon is not usable" do
      it "do nothing" do
        stub(coupon).usable? { false }

        dont_allow(coupon).use!
        dont_allow(coupon).record_order(order)
      end
    end

    context "when coupon is used by the order" do
      it "do nothing" do
        stub(coupon).usable? { true }
        stub(coupon).used_by_order?(order) { true }

        dont_allow(coupon).use!
        dont_allow(coupon).record_order(order)
      end
    end

    context "when coupon is usable and not used by the order" do
      before(:each) do
        stub(order).coupon_id=(numeric)

        stub(coupon).usable? { true }
        stub(coupon).used_by_order?(order) { false }
      end

      it "increase the used_count by 1" do
        lambda {
          coupon.use_and_record_usage_if_applied(order)
        }.should change { coupon.used_count }.by(1)
      end

      it "decrease the available_count by 1" do
        lambda {
          coupon.use_and_record_usage_if_applied(order)
        }.should change { coupon.available_count }.by(-1)
      end

      context "and its available_count is 1" do
        it "expires then" do
          coupon.available_count = 1

          coupon.use_and_record_usage_if_applied(order)

          coupon.should be_expired
        end
      end

      it "bind itself to order" do
        mock(order).coupon_id = coupon.id

        coupon.use_and_record_usage_if_applied(order)
      end
    end
  end
end
