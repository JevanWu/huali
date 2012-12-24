# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    order_id ""
    amount 1
    status "MyString"
    identifier "MyString"
  end
end
