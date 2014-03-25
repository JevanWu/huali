class MonthlySold < ActiveRecord::Base
  belongs_to :product

  scope :by_date, ->(date) { where('sold_year = ? AND sold_month = ?', date.year, date.month) }

  def update_sold_total(quantity)
    update_attribute(:sold_total, sold_total + quantity)
  end
end
