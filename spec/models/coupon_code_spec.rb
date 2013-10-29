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
#
# Indexes
#
#  index_coupon_codes_on_code       (code) UNIQUE
#  index_coupon_codes_on_coupon_id  (coupon_id)
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

  context "check usibility against a order" do
    context "when total price of the order is less than the price condition of coupon code" do
      before(:each) do
        stub(coupon_code).price_condition { 300 }
        stub(order).total { 299 }
      end

      it { should_not be_usable(order) }
    end

    context "when the price_condition has not been set" do
      before(:each) do
        stub(coupon_code).price_condition { nil }
        stub(order).total { 301 }
      end

      it { should be_usable(order) }
    end
  end
end
