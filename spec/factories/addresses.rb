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
#  post_code   :integer
#  province_id :integer
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :address do
    province
    city { province.cities.sample }
    area { city.areas.sample }

    fullname { Forgery(:name).full_name }
    address { Forgery(:address).street_address }
    phone { "+86 186 2137 4266" }
    post_code { 6.times.map { rand 9 }.join }

    trait :with_user do
      user
    end
  end

  factory :province do
    name { Forgery(:address).province}
    post_code { 6.times.map { rand 9 }.join }
    available true

    after(:build) do |prov|
      create_list(:city, Forgery(:basic).number, province: prov )
      # FIXME
      # needs to reload to make the .cities fetch the records just created
      prov.reload
    end

    trait :unavailable do
      available false
    end
  end

  factory :city do
    name { Forgery(:address).city }
    post_code { 6.times.map { rand 9 }.join }
    available true
    province

    after(:build) do |city|
      # FIXME
      # needs to reload to make the .cities fetch the records just created
      create_list(:area, Forgery(:basic).number, city: city )
      city.reload
    end

    trait :unavailable do
      available false
    end
  end

  factory :area do
    name { Forgery(:address).city}
    post_code { 6.times.map { rand 9 }.join }
    available true
    city

    trait :unavailable do
      available false
    end
  end
end
