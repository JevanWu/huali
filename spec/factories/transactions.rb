# == Schema Information
#
# Table name: transactions
#
#  amount            :decimal(8, 2)
#  body              :text
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  identifier        :string(255)
#  merchant_name     :string(255)
#  merchant_trade_no :string(255)
#  order_id          :integer
#  paymethod         :string(255)
#  processed_at      :datetime
#  state             :string(255)      default("generated")
#  subject           :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_transactions_on_identifier  (identifier) UNIQUE
#  index_transactions_on_order_id    (order_id)
#

FactoryGirl.define do
  factory :transaction do
    order
    amount { Forgery(:monetary).money }
    subject { Forgery(:lorem_ipsum).sentence }
    body { Forgery(:lorem_ipsum).paragraph }
    merchant_name { %w(Alipay Paypal Tenpay).sample }
    paymethod { %w(paypal directPay bankPay).sample }
    state { %w(generated wait_check wait_confirm completed).sample }
  end
end
