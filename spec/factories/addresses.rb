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
    province
    city { province.cities.sample }
    area { city.areas.sample }

    fullname { Forgery(:name).full_name }
    address { Forgery(:address).street_address }
    phone { Forgery(:address).phone }
    post_code { Forgery(:address).zip }

    trait :with_user do
      user
    end
  end

  factory :province do
    name { Forgery(:address).province}
    post_code { Forgery(:address).zip }

    after(:build) do |prov|
      create_list(:city, Forgery(:basic).number, province: prov )
    end
  end

  factory :city do
    name { Forgery(:address).city}
    post_code { Forgery(:address).zip }
    province

    after(:build) do |city|
      create_list(:area, Forgery(:basic).number, city: city )
    end
  end

  factory :area do
    name { Forgery(:address).city}
    post_code { Forgery(:address).zip }
    city
  end
end
