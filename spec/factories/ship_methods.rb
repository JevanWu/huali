# == Schema Information
#
# Table name: ship_methods
#
#  cost            :decimal(8, 2)    default(0.0)
#  id              :integer          not null, primary key
#  kuaidi_com_code :string(255)
#  method          :string(255)
#  name            :string(255)
#  service_phone   :string(255)
#  website         :string(255)
#

FactoryGirl.define do
  factory :ship_method do
    cost { Forgery(:monetary).money }
    method { %w(express mannual).sample }
    name { Forgery(:lorem_ipsum).word }
    service_phone { Forgery(:address).phone }
    website { Forgery(:internet).domain_name }
  end
end
