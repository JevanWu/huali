# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipment do
    identifier "MyString"
    state "MyString"
    note "MyText"
    cost 1
    address nil
    ship_method nil
    order nil
  end
end
