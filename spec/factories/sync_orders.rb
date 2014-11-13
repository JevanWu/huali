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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sync_order do
  end
end
