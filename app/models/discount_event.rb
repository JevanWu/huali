# == Schema Information
#
# Table name: discount_events
#
#  created_at     :datetime
#  end_date       :date
#  id             :integer          not null, primary key
#  original_price :decimal(8, 2)
#  price          :decimal(8, 2)
#  product_id     :integer
#  start_date     :date
#  title          :string(255)
#  updated_at     :datetime
#
# Indexes
#
#  index_discount_events_on_end_date    (end_date) UNIQUE
#  index_discount_events_on_product_id  (product_id)
#  index_discount_events_on_start_date  (start_date) UNIQUE
#

class DiscountEvent < ActiveRecord::Base
  belongs_to :product

  validates :product_id, :price, :original_price, :start_date, :end_date, presence: true
  validates :start_date, uniqueness: { scope: :product_id }
  validates :end_date, uniqueness: { scope: :product_id }
  validates :price, :original_price, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validate :start_date_must_not_greater_than_end_date

  scope :today, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
  default_scope -> { order('start_date DESC') }

private

  def start_date_must_not_greater_than_end_date
    return if start_date.blank? || end_date.blank?
    if start_date.to_date > end_date.to_date
      errors.add(:start_date, :start_date_must_not_greater_than_end_date)
    end
  end
end
