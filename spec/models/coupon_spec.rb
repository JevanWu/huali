# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  available_count :integer          default(1), not null
#  code            :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  updated_at      :datetime         not null
#  used_count      :integer          default(0)
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

require 'spec_helper'

describe Coupon do
  pending "add some examples to (or delete) #{__FILE__}"
end
