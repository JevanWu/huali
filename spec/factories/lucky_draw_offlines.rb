# == Schema Information
#
# Table name: lucky_draw_offlines
#
#  created_at :datetime
#  gender     :string(255)
#  id         :integer          not null, primary key
#  mobile     :string(255)
#  name       :string(255)
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lucky_draw_offline do
  end
end
