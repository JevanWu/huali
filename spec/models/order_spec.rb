# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code_id       :integer
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  last_order           :string(255)
#  memo                 :text
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  prechecked           :boolean
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  subject_text         :text             default("")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#  validation_code      :string(255)
#
# Indexes
#
#  index_orders_on_identifier                  (identifier) UNIQUE
#  index_orders_on_merchant_order_no_and_kind  (merchant_order_no,kind)
#  index_orders_on_user_id                     (user_id)
#

require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create(:order, :generated) }

  describe "#skip_payment" do
    let(:order) { FactoryGirl.create(:order, adjustment: "*0") }

    context "when state of the order isn't :generated" do
      let(:order) { FactoryGirl.create(:order, :wait_confirm) }
      it "raise error" do
        -> {
          order.skip_payment
        }.should raise_error(ArgumentError)
      end
    end

    context "when total price of the order isn't 0" do
      it "raise error" do
        -> {
          order.skip_payment
        }.should raise_error(ArgumentError)
      end
    end

    context "when total price of the order is 0 and the state is :generated" do
      it "set the state of order to :wait_check" do
        order.total = 0
        order.skip_payment

        order.state.should == :wait_check
      end
    end
  end

  describe "#generate_refund" do
    let(:order) { FactoryGirl.create(:order, :wait_check, :with_one_transaction) }
    let(:transaction) { create(:transaction, order: order, state: 'completed') }
    let(:refund_money) { 99.0 }

    let(:options) { { merchant_refund_id: '42342342343', reason: "不喜欢" } }

    it "genereates a refund" do
      lambda {
        order.generate_refund(transaction, refund_money, options)
      }.should change { order.refunds.count }.by(1)
    end

    it "set state to 'wait_refund'" do
      order.generate_refund(transaction, refund_money, options)

      order.state.should == 'wait_refund'
    end

    it "genereates a refund with the refund money set to the payment of the transaction if amount is not specified" do
      order.generate_refund(transaction, nil, options)
      order.refunds.last.amount.should == transaction.amount
    end

    context "when the transaction state is not completed" do
      let(:transaction) { create(:transaction, order: order, state: 'generated') }

      it "raise error" do
        lambda {
          order.generate_refund(transaction)
        }.should raise_error(ArgumentError)
      end
    end

    context "the transaction does not belongs to the order" do
      let(:transaction) { create(:transaction, state: 'completed') }

      it "raise error" do
        lambda {
          order.generate_refund(transaction)
        }.should raise_error(ArgumentError)
      end
    end
  end

  it_behaves_like "#to_coupon_rule_opts" do
    subject { order }
  end
end
