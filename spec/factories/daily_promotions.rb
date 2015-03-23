# == Schema Information
#
# Table name: daily_promotions
#
#  created_at :datetime
#  day        :datetime
#  id         :integer          not null, primary key
#  product_id :integer
#  updated_at :datetime
#
# Indexes
#
#  index_daily_promotions_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :daily_promotion do
    day "2015-03-23 16:42:15"
    product nil
  end
end
