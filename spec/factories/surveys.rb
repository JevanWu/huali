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

FactoryGirl.define do
  factory :survey do
    gender :male
    receiver_gender :female
    receiver_age :nineteen_to_25
    relationship :girlfriend
    gift_purpose :propose
    user
  end
end

