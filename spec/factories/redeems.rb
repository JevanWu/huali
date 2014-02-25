# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :redeem do
    title "MyString"
    cost_points 1
    user nil
    order nil
  end
end
