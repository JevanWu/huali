class Banner < ActiveRecord::Base
  def self.fetch_by_date(date)
    where("start_date >= ? and end_date <= ?", date, date)
  end
end
