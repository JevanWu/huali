# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  note            :string(255)
#  price_condition :integer
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Coupon do
  let(:coupon) { create(:coupon) }

  describe "#coupon_code" do
    it "returns the first coupon code record of the coupon" do
      coupon.coupon_code.should == coupon.coupon_codes.first
    end
  end

  describe "#code_count" do
    it "return the total count of coupon code records" do
      coupon.code_count.should == coupon.coupon_codes.count
    end
  end

  describe "#available_count" do
    let(:coupon) { create(:coupon, available_count: 500) }

    it "builds coupon code records with the available count" do
      coupon.coupon_codes.each do |coupon_code|
        coupon_code.available_count.should == 500
      end
    end
  end
end
