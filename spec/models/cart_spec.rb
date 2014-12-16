# == Schema Information
#
# Table name: carts
#
#  coupon_code :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  total_price :decimal(8, 2)    not null
#  updated_at  :datetime
#  user_id     :integer
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#

require 'spec_helper'

describe Cart do
  pending "add some examples to (or delete) #{__FILE__}"
end
