# == Schema Information
#
# Table name: coupons
#
#  adjustment      :string(255)      not null
#  created_at      :datetime         not null
#  expired         :boolean          default(FALSE), not null
#  expires_at      :date             not null
#  id              :integer          not null, primary key
#  note            :string(255)
#  price_condition :integer
#  updated_at      :datetime         not null
#

require 'securerandom'

class Coupon < ActiveRecord::Base
  validates_presence_of :adjustment, :expires_at
  # +/-/*/%1234.0
  validates_format_of :adjustment, with: %r{\A[+-x*%/][\s\d.]+\z}

  has_many :coupon_codes
end
