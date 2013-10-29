# == Schema Information
#
# Table name: coupon_codes
#
#  available_count :integer          default(1)
#  code            :string(255)      not null
#  coupon_id       :integer
#  created_at      :datetime
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  used_count      :integer          default(0)
#
# Indexes
#
#  index_coupon_codes_on_code       (code) UNIQUE
#  index_coupon_codes_on_coupon_id  (coupon_id)
#

class CouponCode < ActiveRecord::Base
  belongs_to :coupon
  before_validation :generate_code, on: :create

  validates_presence_of :code, :available_count

  delegate :price_condition, :adjustment, :expired, :expires_at, :note,
    to: :coupon

  def to_s
    code
  end

  def usable?(order = nil)
    (order ? usable_by_order?(order) : true) &&  # keeps the API call without order or order_form
    !expired &&
    expires_at > Time.current &&
    available_count > 0
  end

  def use!
    self.available_count = self.available_count - 1
    self.used_count = self.used_count + 1

    save
  end

  private

  def usable_by_order?(order)
    price_condition ? order.total >= price_condition : true
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
