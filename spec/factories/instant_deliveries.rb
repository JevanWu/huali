# == Schema Information
#
# Table name: instant_deliveries
#
#  created_at           :datetime
#  delivered_in_minutes :integer          not null
#  fee                  :decimal(8, 2)    default(0.0), not null
#  id                   :integer          not null, primary key
#  order_id             :integer
#  shipped_at           :datetime
#  updated_at           :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :instant_delivery do
    order_id 1
    fee "9.99"
    delivered_at "2014-10-31 14:51:04"
  end
end
