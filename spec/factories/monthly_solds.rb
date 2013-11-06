# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :monthly_sold do
    sold_year 2013
    sold_month 11
    sold_total 100
    product
  end
end
