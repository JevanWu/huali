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

  attr_accessor :code_count, :available_count, :all_use_number, :prefix

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

    if code = generate_code(false, @prefix)
      coupon_codes.create(available_count: 1, code: code)
    end
  end

  private

  def generate_coupon_codes
    code_count.to_i.times do
      if code = generate_code(@all_use_number, @prefix)
        coupon_codes.create(available_count: available_count, code: code) 
      end
    end
  end

  def generate_code(all_use_number=true, prefix=0)
    if all_use_number == "true"
      loop do
        suffix_code = SecureRandom.random_number(9999999)
        generated_code = prefix.to_s + suffix_code.to_s

        unless CouponCode.where(code: generated_code).exists?
          return generated_code.ljust(8, '0')
        end
      end
    else
      loop do
        generated_code = SecureRandom.hex[0...8]

        unless CouponCode.where(code: generated_code).exists?
          return generated_code
        end
      end
    end
  end
end
