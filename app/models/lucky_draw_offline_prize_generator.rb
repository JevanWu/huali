# == Schema Information
#
# Table name: lucky_draw_offline_prize_generators
#
#  collection :string(255)
#  created_at :datetime
#  id         :integer          not null, primary key
#  updated_at :datetime
#

class LuckyDrawOfflinePrizeGenerator < ActiveRecord::Base

  class << self
    def init
      if self.count == 0
        collections = []
        1.times { collections << "a" }
        5.times { collections << "b" }
        9.times { collections << "c" }
        collections.shuffle.each { |c| self.new(collection: c).save }
      end
    end
    def generate
      record = self.take
      record.destroy
      record.collection
    end
  end

end
