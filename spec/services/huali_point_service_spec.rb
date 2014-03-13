require 'spec_helper'

describe HualiPointService do

    let(:inviter) { create(:user) }
    let(:new_user) { create(:user) }
    let(:rewarded_user) { create(:user, invitation_rewarded: true) }
    let(:transaction) { create(:transaction, amount: 500, use_huali_point: true) }

  describe "#reward_point" do
    context "increment the invited and paid counter" do 
      it "should not be successful if this user has been rewarded" do
        described_class.reward_point(inviter, rewarded_user)
        inviter.invited_and_paid_counter.should eq 0
      end

      it "should be successful if this user is a new user" do
        described_class.reward_point(inviter, new_user)
        inviter.invited_and_paid_counter.should eq 1
      end
    end

    context "reward the inviter's huali point" do
      it "should not be successful if the counter has not been 5" do
        described_class.reward_point(inviter, new_user)
        inviter.invited_and_paid_counter.should eq 1
        inviter.huali_point.should eq 0
      end

      it "should be successful and reset the counter once the counter has been 5" do
        inviter.invited_and_paid_counter = 4
        inviter.save
        described_class.reward_point(inviter, new_user)
        inviter.huali_point.should eq 400
        inviter.invited_and_paid_counter.should eq 0
        inviter.point_transactions.count.should eq 1
      end
    end
  end

  describe "#rebate_point" do
    it "rebase 1% huali points" do
      described_class.rebate_point(new_user, transaction)
      new_user.huali_point.should eq 5
      new_user.point_transactions.count.should eq 1
    end
  end

  describe "#minus_expense_point" do
    it "should minus transaction's amount if user's huali point is larger" do
      rewarded_user.huali_point = 600
      described_class.minus_expense_point(rewarded_user, transaction)
      rewarded_user.huali_point.should eq 100
    end

    it "should set user's huali point to 0 if transaction's amount is larger" do
      rewarded_user.huali_point = 200
      described_class.minus_expense_point(rewarded_user, transaction)
      rewarded_user.huali_point.should eq 0
    end
  end
end
