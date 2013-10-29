# == Schema Information
#
# Table name: coupon_codes
#
#  available_count :integer          default(1)
#  code            :string(255)      not null
#  coupon_id       :integer
#  created_at      :datetime
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  used_count      :integer          default(0)
#
# Indexes
#
#  index_coupon_codes_on_code       (code) UNIQUE
#  index_coupon_codes_on_coupon_id  (coupon_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon_code do
    code { 8.times.map { rand 9 }.join }
    available_count 1
    used_count 0
    coupon
  end
end
