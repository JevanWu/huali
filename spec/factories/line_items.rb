# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    order_id ""
    product_id ""
    quantity ""
    price "9.99"
  end
end