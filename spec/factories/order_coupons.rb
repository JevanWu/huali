# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_coupon do
    order nil
    coupon nil
  end
end
