class MonthlySold < ActiveRecord::Base
  belongs_to :product
  
  scope :query_by_date, ->(year, month) { where('sold_year = ? AND sold_month = ?', year, month).take }

  def update_sold_total(quantity)
    update_attribute(:sold_total, sold_total + quantity)
  end
end
