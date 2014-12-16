# == Schema Information
#
# Table name: carts
#
#  coupon_code :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  total_price :decimal(8, 2)    not null
#  updated_at  :datetime
#  user_id     :integer
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
  end
end
