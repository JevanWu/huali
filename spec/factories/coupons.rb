# == Schema Information
#
# Table name: coupons
#
#  adjustment :string(255)      not null
#  code       :string(255)      not null
#  created_at :datetime         not null
#  expires_at :datetime
#  id         :integer          not null, primary key
#  updated_at :datetime         not null
#  used       :boolean          default(FALSE), not null
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    code "MyString"
    adjustment "MyString"
    used false
    expires_at "2013-02-01 17:12:37"
  end
end
