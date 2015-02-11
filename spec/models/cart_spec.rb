# == Schema Information
#
# Table name: carts
#
#  coupon_code_id :integer
#  created_at     :datetime
#  expires_at     :datetime         not null
#  id             :integer          not null, primary key
#  total_price    :decimal(8, 2)    default(0.0), not null
#  updated_at     :datetime
#  user_id        :integer
#
# Indexes
#
#  index_carts_on_coupon_code_id  (coupon_code_id)
#  index_carts_on_user_id         (user_id)
#



require 'spec_helper'

describe Cart do
  pending "add some examples to (or delete) #{__FILE__}"
end
