class Refund < ActiveRecord::Base
  belongs_to :order

  validates :merchant_refund_id, uniqueness: { scope: :order_id }, allow_nil: true
  validates :transaction, :order, :amount, presence: true

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
