# == Schema Information
#
# Table name: carts
#
#  coupon_code_id :integer
#  created_at     :datetime
#  id             :integer          not null, primary key
#  total_price    :decimal(8, 2)    not null
#  updated_at     :datetime
#  user_id        :integer
#
# Indexes
#
#  index_carts_on_coupon_code_id  (coupon_code_id)
#  index_carts_on_user_id         (user_id)
#

class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon_code
  has_many :cart_line_items

  validates :user_id, uniqueness: true

  def use_coupon_code!
    coupon_code.use!
    operator, value = coupon_code.coupon.adjustment.split(//, 2)
    self.total_price = calculate_total_price.send(operator, value.to_d)
  end

  def valid_coupon_code?
    !! coupon_code && coupon_code.usable?(self)
  end

  def get_line_items
    cart_line_items.map(&:to_line_item)
  end

  def calculate_total_price
    cart_line_items.map(&:price).inject(:+)
  end
  def original_total_price
    cart_line_items.map(&:original_price).inject(:+)
  end

  def discounted?
    self.total_price != self.original_total_price
  end

  def discount_money
    original_total_price - total_price
  end

  def discount_rate
    total_price / original_total_price
  end

  def to_coupon_rule_opts
    { total_price: original_total_price, products: products }
  end

  private
  def products
    get_line_items.map(&:product)
  end
end
