# == Schema Information
#
# Table name: lucky_draw_offlines
#
#  age_bracket :string(255)
#  created_at  :datetime
#  gender      :string(255)
#  id          :integer          not null, primary key
#  mobile      :string(255)
#  name        :string(255)
#  prize       :string(255)
#  updated_at  :datetime
#
# Indexes
#
#  index_lucky_draw_offlines_on_mobile  (mobile) UNIQUE
#

class LuckyDrawOffline < ActiveRecord::Base
  extend Enumerize
  enumerize :gender, in: %w[male female]
  enumerize :age_bracket, in: %w[70s 80s 90s]
  enumerize :prize, in: %w[a b c]

  validates :mobile, presence: true, uniqueness: true, phone: { allow_blank: true, types: :mobile }
  validates :prize, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }
  validates :age_bracket, presence: true, inclusion: { in: %w[70s 80s 90s] }
end
