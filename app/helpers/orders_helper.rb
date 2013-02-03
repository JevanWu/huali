module OrdersHelper
  def count_total(item)
    number_to_currency (item[:quantity] * item.price), unit: '&yen;'
  end

  def count_cart(items)
    item_total = items.inject(0.0) {|sum, item| sum + item[:quantity] * item.price}
    number_to_currency item_total, unit: '&yen;'
  end

  def order_state(order)
    case order.state
    when 'generated'
      'warning'
    when 'wait_check'
      'error'
    when 'wait_ship'
      'ok'
    when 'wait_confirm'
      ''
    when 'wait_refund'
      'error'
    when 'completed'
      'ok'
    else
    end
  end

  def order_state_shift(order)
    case order.state
    when "generated"
      link_to(t(:cancel, scope: :order), cancel_admin_order_path(order), confirm: t(:confirm_cancel))
    when "wait_check"
      link_to(t(:check, scope: :order), check_admin_order_path(order), confirm: t(:confirm_check)) + \
      link_to(t(:cancel, scope: :order), cancel_admin_order_path(order), confirm: t(:confirm_cancel))
    when "wait_ship"
      # for historic compatibility, when order(state = checked) doesn't have shipment generated.
      link_to(t(:ship, scope: :order),
              order.shipment.blank? ? new_admin_shipment_path("order[id]" => order.id) : edit_admin_shipment_path(order.shipment),
              confirm: t(:confirm_order_ship)) + \
      link_to(t(:cancel, scope: :order), cancel_admin_order_path(order), confirm: t(:confirm_cancel))
    when "wait_refund"
      link_to(t(:refund, scope: :order), refund_admin_order_path(order))
    when "wait_confirm"
      link_to(t(:confirm, scope: :order), accept_admin_shipment_path(order.shipment), confirm: t(:confirm_accept))
    end
  end
end
