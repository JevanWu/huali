# == Schema Information
#
# Table name: daily_promotions
#
#  created_at :datetime
#  day        :date
#  id         :integer          not null, primary key
#  product_id :integer
#  updated_at :datetime
#
# Indexes
#
#  index_daily_promotions_on_product_id  (product_id)
#

class DailyPromotion < ActiveRecord::Base
  belongs_to :product

  validates :product, presence: true
  validates :day, presence: true, uniqueness: true
end
