module OrdersHelper
  def count_total(item)
    number_to_currency (item[:quantity] * item.price), unit: '&yen;'
  end

  def count_cart(items)
    item_total = items.inject(0.0) {|sum, item| sum + item[:quantity] * item.price}
    number_to_currency item_total, unit: '&yen;'
  end

  def state_shift(order)
    case order.state
    when "generated"
      link_to(t(:pay), new_admin_transaction_path(:"transaction[order_id]" => order.id)) + \
      link_to(t(:cancel), cancel_admin_order_path(order))
    when "wait_check"
      link_to(t(:check), check_admin_order_path(order)) + \
      link_to(t(:cancel), cancel_admin_order_path(order))
    when "wait_ship"
      link_to(t(:ship), new_admin_shipment_path(:"shipment[order_id]" => order.id))
      link_to(t(:cancel), cancel_admin_order_path(order))
    when "wait_refund"
      link_to(t(:refund), refund_admin_order_path(order))
    when "wait_confirm"
      link_to(t(:confirm), confirm_admin_order_path(order))
    end
  end
end
