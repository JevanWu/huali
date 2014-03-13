# == Schema Information
#
# Table name: limited_promotions
#
#  adjustment      :string(255)
#  available_count :integer
#  created_at      :datetime
#  end_at          :datetime
#  expired         :boolean
#  id              :integer          not null, primary key
#  name            :string(255)
#  product_id      :integer
#  start_at        :datetime
#  updated_at      :datetime
#  used_count      :integer          default(0)
#
# Indexes
#
#  index_limited_promotions_on_product_id  (product_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :limited_promotion do
    name "0元秒杀"
    start_at "2014-01-22 15:00:00"
    end_at "2014-01-22 15:10:00"
    adjustment "-299"
    available_count 1
    expired false
    product
  end
end
