# == Schema Information
#
# Table name: period_region_policies
#
#  created_at :datetime
#  end_date   :date
#  id         :integer          not null, primary key
#  not_open   :boolean
#  start_date :date
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :period_region_policy do
    start_date "2013-09-01"
    end_date "2013-09-02"

    after(:build) do |policy|
      policy.create_local_region_rule
    end
  end
end
