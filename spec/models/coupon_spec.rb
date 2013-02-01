# == Schema Information
#
# Table name: coupons
#
#  adjustment :string(255)      not null
#  code       :string(255)      not null
#  created_at :datetime         not null
#  expires_at :datetime
#  id         :integer          not null, primary key
#  updated_at :datetime         not null
#  used       :boolean          default(FALSE), not null
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

require 'spec_helper'

describe Coupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
