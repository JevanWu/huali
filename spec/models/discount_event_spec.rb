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

require 'spec_helper'

describe DiscountEvent do
  pending "add some examples to (or delete) #{__FILE__}"
end
