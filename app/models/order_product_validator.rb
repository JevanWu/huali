# class Order
#   validates_with OrderProductValidator, address: address, items: items
# end
# Configuration options:
# * <tt>:items</tt> - An list of items  (default reads from attributes: record.items)

class OrderProductValidator < ActiveModel::Validator

  attr_reader :items

  def initialize(*)
    super
    @items = options[:items]
  end

  def validate(order)
    @items ||= order.line_items

    if items.blank?
      order.errors.add(:base, :blank_products)
      return
    end

    order_valid = true

    items.each do |line_item|
      unless line_item.published
        line_item.errors.add(:product, :unavailable_product)

        order_valid && order_valid = false
      end

      unless line_item.quantity > 0
        line_item.errors.add(:product, :invalid_quantity)

        order_valid && order_valid = false
      end
    end

    order.errors.add(:base, :unavailable_products) unless order_valid
  end
end
