# == Schema Information
#
# Table name: instant_deliveries
#
#  created_at           :datetime
#  delivered_in_minutes :integer          not null
#  fee                  :decimal(8, 2)    default(0.0), not null
#  id                   :integer          not null, primary key
#  order_id             :integer
#  shipped_at           :datetime
#  updated_at           :datetime
#

class InstantDelivery < ActiveRecord::Base
  belongs_to :order

  def self.used_count_today
    where(shipped_at: Time.current.beginning_of_day .. Time.current.end_of_day).count
  end

  def ship
    self.update_column(:shipped_at, Time.current)
  end
end
