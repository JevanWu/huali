# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  note            :string(255)
#  price_condition :integer
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :coupon do
    adjustment "*0.9"
    price_condition nil
    expired false
    expires_at 30.days.since
    note "Note"

    after(:build) do |coupon|
      create_list(:coupon_code, 5, coupon: coupon)
    end
  end
end
