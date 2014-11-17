# == Schema Information
#
# Table name: lucky_draw_offlines
#
#  created_at :datetime
#  gender     :string(255)
#  id         :integer          not null, primary key
#  mobile     :integer
#  name       :string(255)
#  prize      :string(255)
#  updated_at :datetime
#

class LuckyDrawOffline < ActiveRecord::Base
end
