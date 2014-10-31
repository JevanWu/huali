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
end
