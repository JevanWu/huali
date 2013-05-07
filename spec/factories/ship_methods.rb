# == Schema Information
#
# Table name: ship_methods
#
#  id              :integer          not null, primary key
#  kuaidi_com_code :string(255)
#  method          :string(255)
#  name            :string(255)
#  service_phone   :string(255)
#  website         :string(255)
#

FactoryGirl.define do
  factory :ship_method do
    method 'express'
    name { Forgery(:lorem_ipsum).word }
    service_phone { Forgery(:address).phone }
    website { Forgery(:internet).domain_name }

    trait :manual do
      method 'manual'
    end
  end
end
