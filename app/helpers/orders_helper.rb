module OrdersHelper
  def count_total(item)
    if item[:quantity]
      number_to_currency (item[:quantity] * item.price), unit: '&yen;'
    end
  end

  def count_cart(items)
    if items[0][:quantity]
      item_total = items.inject(0.0) {|sum, item| sum + item[:quantity] * item.price}
      number_to_currency item_total, unit: '&yen;'
    end
  end

  def order_state(order)
    case order.state
    when 'generated'
      'info'
    when 'wait_check'
      'error'
    when 'wait_make'
      'warning'
    when 'wait_ship'
      'ok'
    when 'wait_confirm'
      'inverse'
    when 'wait_refund'
      'error'
    when 'completed'
      'ok'
    else
    end
  end

  def order_state_shift(order)
    buttons = case order.state
    when "generated"
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), confirm: t('views.admin.order.confirm_cancel')) + \
      link_to(t('models.order.state.init_transaction'), new_admin_transaction_path("transaction[order_id]" => order.id,
                                                                      "transaction[amount]" => order.total,
                                                                      "transaction[subject]" => order.subject_text,
                                                                      "transaction[body]" => order.body_text))
    when "wait_check"
      link_to(t(:edit), edit_admin_order_path(order)) + \
      link_to(t('models.order.state.check'), check_admin_order_path(order), confirm: t('views.admin.order.confirm_check')) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), confirm: t('views.admin.order.confirm_cancel'))
    when "wait_make"
      link_to(t('models.order.state.print'), '#', class: 'print') + \
      link_to(t('models.order.state.make'), make_admin_order_path(order), confirm: t('views.admin.order.confirm_make')) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), confirm: t('views.admin.order.confirm_cancel'))
    when "wait_ship"
      # for historic compatibility, when order(state = checked) doesn't have shipment generated.
      link_to(t('models.order.state.ship'),
              if order.shipment.blank?
                new_admin_shipment_path("shipment[order_id]" => order.id,
                                        "shipment[ship_method_id]" => order.ship_method_id)
              else
                edit_admin_shipment_path(order.shipment)
              end
             ) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), confirm: t('views.admin.order.confirm_cancel'))
    when "wait_refund"
      link_to(t('models.order.state.refund'), refund_admin_order_path(order))
    when "wait_confirm"
      link_to(t('models.order.state.confirm'), accept_admin_shipment_path(order.shipment), confirm: t('views.admin.order.confirm_accept')) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), confirm: t('views.admin.order.confirm_cancel'))
    end
    content_tag('div', buttons, id: 'process-buttons')
  end

end
