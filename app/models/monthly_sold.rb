class MonthlySold < ActiveRecord::Base
  belongs_to :product

  scope :current,
    -> { where(sold_year: Date.current.year, sold_month: Date.current.month) }

  def update_sold_total(quantity)
    update_attribute(:sold_total, sold_total + quantity)
  end
end
