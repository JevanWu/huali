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

  validates :code_count, :available_count,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true },
    on: :create

  has_many :coupon_codes
  has_many :orders, through: :coupon_codes
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :products

  after_create :generate_coupon_codes

  attr_writer :code_count, :available_count

  def coupon_code
    coupon_codes.first
  end

  def available_count
    @available_count ||= coupon_code.try(:available_count)
  end

  def code_count
    @code_count ||= coupon_codes.count
  end

  def generate_coupon_code
    return if expired

    coupon_codes.create(available_count: 1)
  end

  private

  def generate_coupon_codes
    code_count.to_i.times do
      self.coupon_codes.create(available_count: available_count)
    end
  end
end
