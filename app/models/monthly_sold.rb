# == Schema Information
#
# Table name: monthly_solds
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  product_id :integer
#  sold_month :integer
#  sold_total :integer          default(0)
#  sold_year  :integer
#  updated_at :datetime
#
# Indexes
#
#  index_monthly_solds_on_product_id                               (product_id)
#  index_monthly_solds_on_product_id_and_sold_year_and_sold_month  (product_id,sold_year,sold_month) UNIQUE
#

class MonthlySold < ActiveRecord::Base
  belongs_to :product

  scope :current,
    -> { where(sold_year: Date.current.year, sold_month: Date.current.month) }

  def update_sold_total(quantity)
    update_attribute(:sold_total, sold_total + quantity)
  end
end
