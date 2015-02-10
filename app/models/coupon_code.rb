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
#  user_id         :integer
#
# Indexes
#
#  index_coupon_codes_on_code       (code) UNIQUE
#  index_coupon_codes_on_coupon_id  (coupon_id)
#  index_coupon_codes_on_user_id    (user_id)
#



class CouponCode < ActiveRecord::Base
  belongs_to :coupon
  has_many :orders
  has_many :carts
  belongs_to :user

  validates_presence_of :code, :available_count

  delegate :price_condition, :adjustment, :expired, :expires_at, :note, :products,
    to: :coupon

  def to_s
    code
  end

  def to_human
    if adjustment.start_with?('*')
      "#{adjustment.sub('*', '').to_f * 10}折优惠劵".sub('.0', '')
    elsif adjustment.start_with?('-')
      "#{adjustment.sub('-', '')}元现金券"
    else
      ''
    end
  end

  def usable?(target = nil)
    (target ? usable_by?(target) : true) &&  # keeps the API call without order or order_form
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

  def usable_by?(target)
    opts = target.to_coupon_rule_opts
    total_price = opts.fetch(:total_price)
    products_in_target = opts.fetch(:products)

    return false if price_condition && total_price < price_condition

    unless products.blank?
      return false if products_in_target.none? { |product| products.include?(product) }
    end

    return false if products_in_target.any? { |product| product.discount? }

    true
  end

end
