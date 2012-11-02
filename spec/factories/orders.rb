# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    number "MyString"
    item_total "9.99"
    total "9.99"
    payment_total "9.99"
    state "MyString"
    payment_state "MyString"
    shipment_state "MyString"
    address nil
    completed_at "2012-11-02 20:46:25"
    user nil
    special_instructions "MyText"
  end
end
