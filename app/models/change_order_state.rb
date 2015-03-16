# == Schema Information
#
# Table name: change_order_states
#
#  administrator_id :integer
#  after_state      :string(255)
#  before_state     :string(255)
#  created_at       :datetime
#  id               :integer          not null, primary key
#  order_id         :integer
#  order_identifier :string(255)
#  updated_at       :datetime
#
# Indexes
#
#  index_change_order_states_on_administrator_id  (administrator_id)
#  index_change_order_states_on_order_id          (order_id)
#

class ChangeOrderState < ActiveRecord::Base
  belongs_to :administrator
  belongs_to :order

  scope :yesterday, -> { where('created_at >= ? AND created_at < ? ', Date.yesterday, Date.current) }
  scope :current, -> { where('created_at >= ? AND created_at < ? ', Date.current, Date.tomorrow) }
  scope :within_this_week, -> { where('created_at >= ? AND created_at <= ? ', Date.current.beginning_of_week, Date.current.end_of_week) }
end
