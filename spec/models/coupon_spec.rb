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

  describe "#apply_usage_for" do
    let(:order) { Object.new }

    context "when coupon is not usable" do
      it "returns false" do
        stub(coupon).usable? { false }

        coupon.apply_usage_for(order).should be_false
      end
    end

    context "when coupon is usable" do
      before(:each) do
        stub(coupon).usable? { true }
        stub(order).coupon_id=(numeric)
      end

      it "increase the used_count by 1" do
        lambda {
          coupon.apply_usage_for(order)
        }.should change { coupon.used_count }.by(1)
      end

      it "decrease the available_count by 1" do
        lambda {
          coupon.apply_usage_for(order)
        }.should change { coupon.available_count }.by(-1)
      end

      context "and its available_count is 1" do
        it "expires then" do
          coupon.available_count = 1

          coupon.apply_usage_for(order)

          coupon.expired.should be_true
        end
      end

      it "bind itself to order" do
        mock(order).coupon_id = coupon.id

        coupon.apply_usage_for(order)
      end
    end
  end
end
