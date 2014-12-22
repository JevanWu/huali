# == Schema Information
#
# Table name: print_orders
#
#  card_printed     :boolean          default(FALSE)
#  created_at       :datetime
#  id               :integer          not null, primary key
#  order_id         :integer
#  order_printed    :boolean          default(FALSE)
#  print_group_id   :integer
#  shipment_printed :boolean          default(FALSE)
#  updated_at       :datetime
#
# Indexes
#
#  index_print_orders_on_order_id        (order_id) UNIQUE
#  index_print_orders_on_print_group_id  (print_group_id)
#

class PrintOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :print_group

  validates :order, uniqueness: true

  default_scope { order("created_at") }

  scope :query_by_delivery_date, -> (delivery_date){joins(:order).where(orders: {delivery_date: delivery_date})}
  scope :query_by_product, -> (product_id){joins("JOIN line_items ON line_items.order_id = print_orders.order_id").where(line_items: {product_id: product_id})}

  def self.from_order(order)
    print_group = PrintGroup.where(ship_method: order.ship_method).sample
    create(order: order, print_group: print_group) if print_group
  end
end
