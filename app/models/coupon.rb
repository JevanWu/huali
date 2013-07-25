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
#  note            :string(255)
#  updated_at      :datetime         not null
#  used_count      :integer          default(0)
#
# Indexes
#
#  coupons_on_code  (code) UNIQUE
#

require 'securerandom'

class Coupon < ActiveRecord::Base
  attr_accessible :adjustment, :expires_at, :available_count, :note

  before_validation :generate_code, on: :create

  validates_presence_of :adjustment, :code, :expires_at, :available_count
  # +/-/*/%1234.0
  validates_format_of :adjustment, with: %r{\A[+-x*%/][\s\d.]+\z}

  has_many :orders

  def use_and_record_usage_if_applied(order)
    if usable? && !used_by_order?(order)
      use! and record_order(order)
    end
  end

  def used_by_order?(order)
    order.coupon && order.coupon == self
  end

  def usable?
    ! (expired || Time.current > expires_at || available_count == 0)
  end

  def to_s
    code
  end

  private

  def record_order(order)
    order.coupon_id = id
  end

  def use!
    self.available_count = self.available_count - 1
    self.used_count = self.used_count + 1
    self.expired = self.available_count <= 0

    save
  end

  def generate_code
    loop do
      generated_code = SecureRandom.hex[0...8]

      unless self.class.where(code: generated_code).exists?
        self.code = generated_code and break
      end
    end
  end
end
