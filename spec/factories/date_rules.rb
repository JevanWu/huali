# == Schema Information
#
# Table name: date_rules
#
#  created_at        :datetime         not null
#  end_date          :date
#  excluded_dates    :text
#  excluded_weekdays :string(255)
#  id                :integer          not null, primary key
#  included_dates    :text
#  name              :string(255)
#  product_id        :integer
#  start_date        :date
#  type              :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_date_rules_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :local_date_rule do
    start_date "2013-01-01"
    end_date "2013-02-01"

    included_dates ["2013-02-02", "2013-02-05"]
    excluded_dates ["2013-01-02", "2013-01-05"]
    excluded_weekdays ["6","0"]
    product
  end

  factory :default_date_rule do
    start_date "2013-01-01"
    end_date "2013-12-01"

    included_dates []
    excluded_dates []
    excluded_weekdays []
    sequence(:name) { |n| "name#{n}" }
  end
end
