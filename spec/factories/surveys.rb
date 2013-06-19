# == Schema Information
#
# Table name: surveys
#
#  created_at      :datetime         not null
#  gender          :string(255)
#  gift_purpose    :string(255)
#  id              :integer          not null, primary key
#  receiver_gender :string(255)
#  updated_at      :datetime         not null
#  user_id         :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey do
    gender "MyString"
    receiver_gender "MyString"
    gift_purpose "MyString"
  end
end
