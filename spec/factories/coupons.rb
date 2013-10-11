# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  available_count :integer          default(1), not null
#  code            :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  note            :string(255)
#  price_condition :integer
#  updated_at      :datetime         not null
#  used_count      :integer          default(0)
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

FactoryGirl.define do
  factory :coupon do
    adjustment "*0.9"
    available_count 100
    used_count 5
    sequence(:code) { |n| "00880#{n}" }
    price_condition nil
    expired false
    expires_at 30.days.since
    note "Note"
  end
end
