require 'spec_helper'

describe LimitedPromotion do
  let(:limited_promotion) { create(:limited_promotion) }

  subject { limited_promotion }

  describe "#close_to_start_time?" do
    context "when start time is greater than current time by 10 minutes" do
      let(:limited_promotion) { create(:limited_promotion, start_at: 9.minutes.since) }

      it "returns true" do
        subject.should be_close_to_start_time
      end
    end

    context "when start time is greater than current time by more than 30 minutes" do
      let(:limited_promotion) { create(:limited_promotion, start_at: 31.minutes.since) }

      it "returns false" do
        subject.should_not be_close_to_start_time
      end
    end
  end

  describe "#started?" do
    context "when start time is less than or equal to current time" do
      let(:limited_promotion) { create(:limited_promotion, start_at: 1.minutes.ago) }

      it "returns true" do
        subject.should be_started
      end
    end

    context "when start time is still greater than the current time" do
      let(:limited_promotion) { create(:limited_promotion, start_at: 1.minutes.since) }

      it "returns false" do
        subject.should_not be_started
      end
    end
  end

  describe "#expired?" do
    context "when it was manually set to expired" do
      let(:limited_promotion) { create(:limited_promotion, expired: true) }

      it "returns true" do
        subject.should be_expired
      end
    end

    context "when its was not manually set to expired" do
      context "when end time is greater than the current time" do
        let(:limited_promotion) { create(:limited_promotion, end_at: 1.minutes.since) }

        it "returns false" do
          subject.should_not be_expired
        end
      end

      context "when end time is less than the current time" do
        let(:limited_promotion) { create(:limited_promotion, end_at: 1.minutes.ago) }

        it "returns true" do
          subject.should be_expired
        end
      end
    end
  end

end
