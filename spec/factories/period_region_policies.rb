# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :period_region_policy do
    start_date "2013-09-01"
    end_date "2013-09-02"
    customized_region_rule
  end
end
