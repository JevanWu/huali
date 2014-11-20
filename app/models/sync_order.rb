# == Schema Information
#
# Table name: sync_orders
#
#  administrator_id  :integer
#  created_at        :datetime
#  id                :integer          not null, primary key
#  kind              :string(255)
#  merchant_order_no :string(255)
#  order_id          :integer
#  updated_at        :datetime
#
# Indexes
#
#  index_sync_orders_on_administrator_id  (administrator_id)
#  index_sync_orders_on_order_id          (order_id)
#

class SyncOrder < ActiveRecord::Base
  extend Enumerize
  enumerize :kind, in: [ :taobao, :tmall, :jd, :yhd, :amazon ]

  belongs_to :administrator
  belongs_to :order

  validates :kind, presence: true
  validates :merchant_order_no, presence: true, uniqueness: { scope: :kind }

  scope :yesterday, -> { where('created_at >= ? AND created_at < ? ', Date.yesterday, Date.current) }
  scope :current, -> { where('created_at >= ? AND created_at < ? ', Date.current, Date.tomorrow) }
  scope :within_this_week, -> { where('created_at >= ? AND created_at <= ? ', Date.current.beginning_of_week, Date.current.end_of_week) }

  def already_synced_by_poller?
    Order.where(merchant_order_no: self.merchant_order_no).exists?
  end

end
