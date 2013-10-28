# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon_code do
    code "MyString"
    available_count 1
    used_count 1
    coupon nil
  end
end
