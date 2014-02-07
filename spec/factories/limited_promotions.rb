# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :limited_promotion do
    name "0元秒杀"
    start_at "2014-01-22 15:00:00"
    end_at "2014-01-22 15:10:00"
    adjustment "-299"
    available_count 1
    expired false
    product
  end
end
