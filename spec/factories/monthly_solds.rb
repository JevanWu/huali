# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_sold do
    sold_year { Date.current.year }
    sold_month { Date.current.month }
    sold_total 100
    product
  end
end
