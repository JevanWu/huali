class MonthlySold < ActiveRecord::Base
  belongs_to :product

  def update_sold_total(quantity)
    update_attribute(:sold_total, sold_total + quantity)
  end
end
