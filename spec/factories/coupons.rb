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
    code_count { 5 }
    available_count { 1 }

    trait :with_products_limitation do
      after(:build) do |coupon|
        coupon.products = create_list(:product, 2)
      end
    end
  end
end
