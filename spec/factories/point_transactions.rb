# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :point_transaction do
    point 1
    transaction_type "MyString"
    description "MyString"
    expires_on "2014-02-26"
    user nil
    transaction nil
  end
end
