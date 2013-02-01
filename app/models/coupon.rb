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

require 'securerandom'

class Coupon < ActiveRecord::Base
  attr_accessible :adjustment, :expires_at, :available_count

  before_validation :generate_code, on: :create

  validates_presence_of :adjustment, :code, :expires_at, :available_count
  # +/-/*/%1234.0
  validates_format_of :adjustment, :with => %r{\A[+-x*%/][\s\d.]+}

  has_many :order_coupons
  has_many :orders, through: :order_coupon

  def use!
    return false unless usable?

    self.available_count = self.available_count - 1
    self.used_count = self.used_count + 1

    if self.available_count <= 0
      self.expired = true
    end

    if self.save
      return adjustment
    else
      return false
    end
  end

  def usable?
    if expired || Time.current > expires_at || available_count == 0
      return false
    else
      return true
    end
  end

  private

  def generate_code
    self.code = SecureRandom.hex[0...8]
  end
end
