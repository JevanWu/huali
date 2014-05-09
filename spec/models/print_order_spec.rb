# == Schema Information
#
# Table name: print_orders
#
#  card_printed     :boolean          default(FALSE)
#  created_at       :datetime
#  id               :integer          not null, primary key
#  order_id         :integer
#  order_printed    :boolean          default(FALSE)
#  print_group_id   :integer
#  shipment_printed :boolean          default(FALSE)
#  updated_at       :datetime
#
# Indexes
#
#  index_print_orders_on_order_id        (order_id) UNIQUE
#  index_print_orders_on_print_group_id  (print_group_id)
#

require 'spec_helper'

describe PrintOrder do
  pending "add some examples to (or delete) #{__FILE__}"
end
