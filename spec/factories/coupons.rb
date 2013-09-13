FactoryGirl.define do
  factory :coupon do
    adjustment "*0.9"
    available_count 100
    used_count 5
    sequence(:code) { |n| "00880#{n}" }
    price_condition nil
    expired false
    expires_at 30.days.since
    note "Note"
  end
end
