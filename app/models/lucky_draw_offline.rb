# == Schema Information
#
# Table name: lucky_draw_offlines
#
#  created_at :datetime
#  gender     :string(255)
#  id         :integer          not null, primary key
#  mobile     :string(255)
#  name       :string(255)
#  prize      :string(255)
#  updated_at :datetime
#

class LuckyDrawOffline < ActiveRecord::Base
  validates :mobile, presence: true, numericality: true, length: { is: 11 }
  validates :name, presence: true
  validates :prize, presence: true
  validates :gender, presence: true, inclusion: { in: [ "male", "female" ] }
end
