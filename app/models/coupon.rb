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

require 'securerandom'

class Coupon < ActiveRecord::Base
  attr_accessible :adjustment, :code, :expires_at, :used

  before_validation :generate_code, on: :create

  validates_presence_of :adjustment, :code, :expires_at
  # +/-/*/%1234.0
  validates_format_of :adjustment, :with => %r{\A[+-x*%/][\s\d.]+}

  def use!
    return false unless valid?
    self.used = true
    if self.save!
      return adjustment
    else
      return false
    end
  end

  def usable?
    not used && (Time.current < expireds_at)
  end

  private

  def generate_code
    self.code = SecureRandom.hex[0...8]
  end
end
