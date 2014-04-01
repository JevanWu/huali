require 'spec_helper'
require 'bigdecimal'
require 'bigdecimal/util'

describe HualiPointService do

  let(:inviter) { create(:user) }
  let(:new_user) { create(:user) }
  let(:rewarded_user) { create(:user, invitation_rewarded: true) }
  let(:transaction) { create(:transaction, amount: 500) }

  describe "#reward_invitee_point" do
    it "reward the invitee's huali point" do
      described_class.reward_invitee_point( new_user)
      new_user.huali_point.should eq 20
      new_user.point_transactions.count.should eq 1
    end
  end

  describe "#reward_inviter_point" do
    context "increment the invited and paid counter" do 
      it "should not be successful if this user has been rewarded" do
        described_class.reward_inviter_point(inviter, rewarded_user)
        inviter.invited_and_paid_counter.should eq 0
      end

      it "should be successful if this user is a new user" do
        described_class.reward_inviter_point(inviter, new_user)
        inviter.invited_and_paid_counter.should eq 1
      end
    end

    it "reward the inviter's huali point" do
      described_class.reward_inviter_point(inviter, new_user)
      inviter.huali_point.should eq 80
      inviter.invited_and_paid_counter.should eq 1
      inviter.point_transactions.count.should eq 1
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
    before do
      transaction.order.total = 500
      transaction.use_huali_point = true
    end

    it "should minus transaction's amount if user's huali point is larger" do
      rewarded_user.huali_point = 600
      described_class.minus_expense_point(rewarded_user, transaction)
      rewarded_user.huali_point.to_i.should eq 100
    end

    it "should set user's huali point to 0 if transaction's amount is larger" do
      rewarded_user.huali_point = 200
      described_class.minus_expense_point(rewarded_user, transaction)
      rewarded_user.huali_point.should eq 0
    end
  end

  describe "#process_refund" do
    context "transaction use huali point" do
      before do
        transaction.use_huali_point = true
        transaction.order.total = 500
      end

      it "returns the huali points to user if user buy the product purely by using huali point" do
        described_class.process_refund(rewarded_user, transaction)
        rewarded_user.huali_point.should eq 500
      end

      it "returns the huali points to user if user buy the product by using huali point and money" do
        transaction.order.total = 600
        described_class.process_refund(rewarded_user, transaction)
        rewarded_user.huali_point.should eq 100
      end
    end

    context "transaction don't use huali point" do
      before do
        rewarded_user.huali_point = 100
        transaction.use_huali_point = false
        transaction.amount = 500
      end

      it "should recover the 1% huali point" do
        described_class.process_refund(rewarded_user, transaction)
        rewarded_user.huali_point.should eq 95
      end
    end
  end
end
