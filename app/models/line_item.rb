class LineItem < ActiveRecord::Base
  # :price, :order_id is only altered internally
  attr_accessible :product_id, :quantity

  belongs_to :order
  belongs_to :product

  before_validation :adjust_quantity, :copy_price

  validates :product, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :message => ('quantity must be numbers.'), :greater_than => -1 }
  validates :price, :numericality => true

  # after_save :update_order
  # after_destroy :update_order

  def copy_price
    self.price = product.price if product && price.nil?
  end

  def increment_quantity
    self.quantity += 1
  end

  def decrement_quantity
    self.quantity -= 1
  end

  def amount
    price * quantity
  end
  alias total amount

  def adjust_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def sufficient_stock?
    if new_record? || !order.completed?
      product.count_on_hand >= quantity
    else
      product.count_on_hand >= (quantity - self.changed_attributes['quantity'].to_i)
    end
  end

  def insufficient_stock?
    !sufficient_stock?
  end

  private
    def update_order
      # update the order totals, etc.
      order.update!
    end
end