# == Schema Information
#
# Table name: line_items
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  order_id   :integer
#  product_id :integer
#  quantity   :integer          not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_line_items_on_order_id    (order_id)
#  index_line_items_on_product_id  (product_id)
#

class LineItem < ActiveRecord::Base
  # :price, :order_id is only altered internally
  attr_accessible :product_id, :quantity

  belongs_to :order
  belongs_to :product

  before_validation :adjust_quantity

  validates :product, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :message => ('quantity must be numbers.'), :greater_than => -1 }

  delegate :assets, :price, :name, :to => :product

  # after_save :update_order
  # after_destroy :update_order

  def increment_quantity
    self.quantity += 1
  end

  def decrement_quantity
    self.quantity -= 1
  end

  def total
    price * quantity
  end

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
