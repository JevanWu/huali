# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  adjustment           :string(255)
#  completed_at         :datetime
#  coupon_code          :string(255)
#  created_at           :datetime         not null
#  delivery_date        :date
#  expected_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_total        :decimal(8, 2)    default(0.0)
#  printed              :boolean          default(FALSE)
#  sender_email         :string(255)
#  sender_name          :string(255)
#  sender_phone         :string(255)
#  ship_method_id       :string(255)
#  source               :string(255)      default(""), not null
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  type                 :string(255)      default("normal"), not null
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
  describe "#update_sold_total" do
    let(:order) { FactoryGirl.create(:order, :wait_confirm) }

    it 'is called after order state changes to complete' do
      order.should_receive(:update_sold_total).once
      order.confirm
    end

    it 'increments the products quantity by the line items quantity' do
      former_quantities = order.line_items.map(&:sold_total)
      increment_amounts = order.line_items.map(&:quantity)

      order.send(:update_sold_total)

      result_quantities = order.line_items.map(&:sold_total)

      former_quantities.each_with_index do |amount, i|
        (former_quantities[i] + increment_amounts[i]).should == result_quantities[i]
      end
    end
  end
end
