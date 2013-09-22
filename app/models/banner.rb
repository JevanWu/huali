class Banner < ActiveRecord::Base
  default_scope { order("created_at") }

  def self.fetch_by_date(date)
    where("start_date <= ? AND end_date >= ?", date, date)
  end
end
