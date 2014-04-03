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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :refund do
    order
    transaction
    state "pending"
    merchant_refund_id { SecureRandom.hex(6) }
    amount "299.0"
    reason "不喜欢"
    ship_method "EMS"
    tracking_number { SecureRandom.hex(4) }
  end
end
