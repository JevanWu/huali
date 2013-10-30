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

  validates :price_condition,
    numericality: { only_integer: true, greater_than_or_equal_to: 1 },
    allow_blank: true

  validates :code_count,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true },
    on: :create

  has_many :coupon_codes
  has_many :orders, through: :coupon_codes

  after_create :generate_coupon_codes

  attr_writer :code_count

  def code_count
    @code_count ||= coupon_codes.count
  end

  private

  def generate_coupon_codes
    code_count.to_i.times do
      self.coupon_codes.create
    end
  end
end
