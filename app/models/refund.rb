# == Schema Information
#
# Table name: refunds
#
#  amount             :decimal(, )
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  merchant_refund_id :string(255)
#  order_id           :integer
#  reason             :string(255)
#  ship_method        :string(255)
#  state              :string(255)
#  tracking_number    :string(255)
#  transaction_id     :integer
#  updated_at         :datetime
#
# Indexes
#
#  index_refunds_on_order_id                         (order_id)
#  index_refunds_on_order_id_and_merchant_refund_id  (order_id,merchant_refund_id) UNIQUE
#  index_refunds_on_transaction_id                   (transaction_id)
#

class Refund < ActiveRecord::Base
  belongs_to :order
  belongs_to :transaction

  validates :merchant_refund_id, uniqueness: { scope: :order_id }, allow_nil: true
  validates :transaction, :order, :amount, presence: true

  validates :ship_method, presence: true, if: Proc.new { |refund| refund.tracking_number? }
  validates :tracking_number, presence: true, if: Proc.new { |refund| refund.ship_method? }

  after_save do |refund|
    if refund.state == 'pending' && refund.ship_method? && refund.tracking_number?
      refund.return_goods
    end
  end

  state_machine :state, initial: :pending do
    state :pending do
      transition to: :accepted, on: :accept
      transition to: :rejected, on: :reject

      transition to: :goods_returned, on: :return_goods
    end

    state :goods_returned do
      validates :ship_method, :tracking_number, presence: true

      transition to: :accepted, on: :accept
      transition to: :rejected, on: :reject
    end
  end
end
