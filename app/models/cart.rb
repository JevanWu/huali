# == Schema Information
#
# Table name: carts
#
#  coupon_code_id :integer
#  created_at     :datetime
#  expires_at     :datetime         not null
#  id             :integer          not null, primary key
#  total_price    :decimal(8, 2)    default(0.0), not null
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
  has_many :cart_line_items, dependent: :destroy

  validates :user_id, uniqueness: true

  before_save :update_total_price, :update_expiry_date

  def update_expiry_date
    self.expires_at = Time.now.tomorrow.strftime("%Y-%m-%d %H:%M")
  end

  def update_expiry_date!
    self.update_column(:expires_at, Time.now.tomorrow.strftime("%Y-%m-%d %H:%M"))
  end

  def expiry_date
    expires_at.strftime "%Y-%m-%d %H:%M"
  end

  def expired?
    Time.now < expires_at ? false : true
  end

  def has_discounted_items?
    get_line_items.any? { |item| item.product.discount? }
  end

  def total_quantity
    cart_line_items.map(&:quantity).inject(0) { |i1, i2| i1 + i2 }
  end

  def get_item_by(product_id)
    self.cart_line_items.find_by product_id: product_id
  end

  def valid_coupon_code?
    !! coupon_code && coupon_code.usable?(self)
  end

  def get_line_items
    cart_line_items.map(&:to_line_item)
  end
  alias_method :order_line_items, :get_line_items

  # return cart_line_items could use cart_coupon_code
  # return all if cart.coupon_code is nil
  def cart_line_items_could_use_coupon_code
    return cart_line_items unless self.coupon_code_id
    self.cart_line_items.select { |pro_id| self.coupon_code.products.pluck(:id).include?(pro_id) }
  end

  def calculate_total_price
    return 0.00 if cart_line_items.empty?

    total_price = cart_line_items.map do |item|
      # fix me: I'm ugly ....
      if adjustment.present? and ( coupon_code.products.pluck(:id).include?(item.product_id) or coupon_code.products.empty? )
        Discount.new(adjustment).calculate(item.unit_price) * item.quantity
      else
        item.total_price  
      end
      # fix me: I'm ugly ....
    end.inject(:+)

    if limited_promotion_today && limited_promotion_today.usable?
      total_price = [Discount.new(limited_promotion_today.adjustment).calculate(total_price), 0].max
    end

    total_price ? total_price : 0.00
  end

  def update_total_price
    self.total_price = self.calculate_total_price
  end

  def update_total_price!
    self.update_column(:total_price, self.calculate_total_price)
  end

  def adjustment
    @adjustment ||= (self.valid_coupon_code? ? self.coupon_code.adjustment : nil)
  end

  def original_total_price
    cart_line_items.map(&:original_total_price).inject(:+)
  end

  def discounted?
    total_price != original_total_price
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

  def limited_promotion_today
    products.each do |p|
      return p.limited_promotion_today if p.limited_promotion_today
    end
    nil
  end

  private

  def products
    get_line_items.map(&:product)
  end

end
