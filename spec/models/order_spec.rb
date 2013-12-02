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
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  kind                 :string(255)      default("normal"), not null
#  merchant_order_no    :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :integer
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#  index_orders_on_user_id     (user_id)
#

require 'spec_helper'

describe Order do

  let(:order) { FactoryGirl.create(:order, adjustment: "*0") }

  describe "#skip_payment" do
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

  it_behaves_like "#to_coupon_rule_opts" do
    subject { order }
  end
end
