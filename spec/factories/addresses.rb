# == Schema Information
#
# Table name: addresses
#
#  address     :string(255)
#  area_id     :integer
#  city_id     :integer
#  created_at  :datetime         not null
#  fullname    :string(255)
#  id          :integer          not null, primary key
#  phone       :string(255)
#  post_code   :string(255)
#  province_id :integer
#  updated_at  :datetime         not null
#  user_id     :integer
#

FactoryGirl.define do
  factory :address do
    province_id { Province.all.sample.id }
    city_id { Province.find(province_id).cities.sample.id }
    area_id { City.find(city_id).areas.sample.id }

    fullname { Forgery(:name).full_name }
    address ( Forgery(:address).street_address )
    phone ( Forgery(:address).phone )
    post_code ( Forgery(:address).zip )

    trait :with_user do
      user
    end
  end
end
