require 'spec_helper'

describe DidiPassengerReceiveCouponService do
  describe "#receive_coupon_code" do
    let(:coupon) { create(:coupon) }

    let(:didi_passenger) { create(:didi_passenger) }

    context "when fail to generate new coupon code" do
      it "raise error" do
        stub(coupon).generate_coupon_code { nil }

        lambda {
          described_class.receive_coupon_code(didi_passenger, coupon)
        }.should raise_error
      end
    end

    it "bind the new coupon code to didi_passenger" do
      described_class.receive_coupon_code(didi_passenger, coupon)

      didi_passenger.coupon_code.should eq(coupon.coupon_codes.last)
    end

    it "send the coupon code to phone of didi_passenger by sms" do
      described_class.receive_coupon_code(didi_passenger, coupon)
    end
  end
end
