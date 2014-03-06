# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :refund do
    order
    state "pending"
    merchant_trade_no { SecureRandom.hex(8) }
    merchant_refund_id { SecureRandom.hex(6) }
    amount "299.0"
    reason "不喜欢"
    ship_method "EMS"
    tracking_number { SecureRandom.hex(4) }
  end
end
