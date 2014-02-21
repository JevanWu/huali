# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :slide_panel do
    name { Forgery(:lorem_ipsum).word }
    href "/"
    priority 1
    visible false
  end
end
