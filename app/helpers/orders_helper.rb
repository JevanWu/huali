module OrdersHelper
  def order_shift(order)
    case order.state
    when "generated"
      link_to(t(:pay), pay_admin_order_path(order)) + \
      link_to(t(:cancel), cancel_admin_order_path(order))
    when "wait_check"
      link_to(t(:check), check_admin_order_path(order)) + \
      link_to(t(:cancel), cancel_admin_order_path(order))
    when "wait_ship"
      link_to(t(:ship), ship_admin_order_path(order)) + \
      link_to(t(:cancel), refund_admin_order_path(order))
    when "wait_refund"
      link_to(t(:refund), refund_admin_order_path(order))
    when "wait_confirm"
      link_to(t(:confirm), confirm_admin_order_path(order))
    end
  end
end
