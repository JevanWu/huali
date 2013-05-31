# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey do
    gender "MyString"
    receiver_gender "MyString"
    gift_purpose "MyString"
  end
end
