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
#  index_discount_events_on_product_id                 (product_id)
#  index_discount_events_on_product_id_and_end_date    (product_id,end_date) UNIQUE
#  index_discount_events_on_product_id_and_start_date  (product_id,start_date) UNIQUE
#

require 'spec_helper'

describe DiscountEvent do
  pending "add some examples to (or delete) #{__FILE__}"
end
