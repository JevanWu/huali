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

require 'spec_helper'

describe SyncOrder do
  pending "add some examples to (or delete) #{__FILE__}"
end
