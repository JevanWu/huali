# == Schema Information
#
# Table name: ship_methods
#
#  cost            :integer
#  id              :integer          not null, primary key
#  kuaidi_com_code :string(255)
#  method          :string(255)
#  name            :string(255)
#  service_phone   :string(255)
#  website         :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship_method do
    tracking_num "MyString"
    name "MyString"
    service_phone "MyString"
    type ""
    website "MyString"
  end
end
