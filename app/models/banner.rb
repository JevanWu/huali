# == Schema Information
#
# Table name: banners
#
#  content    :string(255)
#  created_at :datetime
#  end_date   :date
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :date
#  updated_at :datetime
#

class Banner < ActiveRecord::Base
  default_scope { order("created_at") }

  def self.fetch_by_date(date)
    where("start_date <= ? AND end_date >= ?", date, date)
  end
end
