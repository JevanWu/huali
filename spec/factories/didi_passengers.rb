# == Schema Information
#
# Table name: didi_passengers
#
#  coupon_code_id :integer
#  created_at     :datetime
#  id             :integer          not null, primary key
#  name           :string(255)
#  phone          :string(255)
#  updated_at     :datetime
#
# Indexes
#
#  index_didi_passengers_on_coupon_code_id  (coupon_code_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :didi_passenger do
    name "A name"
    phone "18611112222"
  end
end
