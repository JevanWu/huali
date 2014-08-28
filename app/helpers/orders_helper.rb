module OrdersHelper
  def count_total(item)
    number_to_currency (item.quantity * item.price)
  end

  def count_cart(items)
    item_total = items.inject(0.0) {|sum, item| sum + item.quantity * item.price}
    number_to_currency item_total
  end

  def link_to_add_row_partial(name, link, product, partial_name)
    product.quantity ||= 1
    # FIXME how to direct compile the erb
    row_html = render(partial: partial_name, collection: [product]).to_str

    link_to name, link, data: { product_id: product.id, field_for_table: row_html }
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

  def print_order(order)
    buttons =
    link_to(t('models.order.state.print'), print_admin_order_path(order), { target: '_blank' }) + \
    link_to(t('models.order.state.print_card'), print_card_admin_order_path(order), { target: '_blank' }) + \
    link_to(t('models.order.state.print_shipment'), print_shipment_admin_order_path(order), { target: '_blank' })

    content_tag('div', buttons, id: 'print-buttons')
  end

  def order_state_shift(order)
    return if current_admin_ability.cannot? :update, Order

    buttons = case order.state
    when "generated"

      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_cancel') }) + \
      link_to(t('models.order.state.init_transaction'), new_admin_transaction_path("transaction[order_id]" => order.id,
                                                                      "transaction[amount]" => order.total,
                                                                      "transaction[subject]" => order.subject_text,
                                                                      "transaction[body]" => order.body_text))
    when "wait_check"
      link_to(t(:edit), edit_admin_order_path(order)) + \
      link_to(t('models.order.state.check'), check_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_check') }) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_cancel') })
    when "wait_make"
      link_to(t('models.order.state.add_shipment'), add_shipment_admin_order_path(order), target: '_blank') + \
      link_to(t('models.order.state.make'), make_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_make') }) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_cancel') })
    when "wait_ship"
      # for historic compatibility, when order(state = checked) doesn't have shipment generated.
      link_to(t('models.order.state.ship'),
              if order.shipment.blank?
                new_admin_shipment_path("shipment[order_id]" => order.id,
                                        "shipment[ship_method_id]" => order.ship_method_id)
              else
                admin_shipment_path(order.shipment)
              end
             ) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_cancel') }) + \
      (order.user ? link_to(t('models.user.binding_coupon_code'), binding_coupon_code_admin_user_path(order.user)) : '')
    when "wait_refund"
      link_to(t('models.order.state.refund'), refund_admin_order_path(order))
    when "wait_confirm"
      link_to(t('models.order.state.confirm'), accept_admin_shipment_path(order.shipment), data: { confirm: t('views.admin.order.confirm_accept') }) + \
      link_to(t('models.order.state.cancel'), cancel_admin_order_path(order), data: { confirm: t('views.admin.order.confirm_cancel') }) + \
      (order.user ? link_to(t('models.user.binding_coupon_code'), binding_coupon_code_admin_user_path(order.user)) : '')
    end
    content_tag('div', buttons, id: 'process-buttons')
  end

  def link_to_add_line_items(name, f, all_line_items)
    new_line_item = ItemInfo.new
    id = new_line_item.object_id
    fields_html = render({ partial: 'line_item_fields',
                           locals: {
                              f: f,
                              line_item_fields: new_line_item,
                              all_line_items: all_line_items }})

    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields_html.gsub('\n', '')})
  end

  def simple_form_error_messages_for(collection)
    item_errors = collection.map do |item|
      item.errors[:base].map do |err|
        content_tag('span', err, class: 'help-block')
      end
    end.flatten.join.html_safe

    if item_errors.present?
      content_tag('div', item_errors, class: "control-group error section-error")
    end
  end

  def formtastic_error_messages_for(collection)
    item_errors = collection.map do |item|
      item.errors[:base].map do |err|
        content_tag('li', err)
      end
    end.flatten.join.html_safe

    if item_errors.present?
      content_tag('ul', item_errors, class: "errors")
    end
  end

  def express_query_links
    <<-STR
      <a href="http://cndxp.apac.fedex.com/app/transittime?method=init&language=zh&region=CN" target="_blank">联邦查询</a>
      <a href="http://www.sf-express.com/cn/sc/delivery_step/enquiry/serviceTime.html" target="_blank">顺丰查询</a>
    STR
  end

  def discount_amount(order)
    original_price = 0
    order.line_items.each{ |item| original_price += item.price * item.quantity }
    real_pay = order.transaction.try(:amount) || 0
    original_price - real_pay
  end

  def checkout_path(use_wechat_agent, order)
    if use_wechat_agent
      checkout_order_path(order)
    else
      wechat_payment_path(order, showwxpaytitle: 1)
    end
  end
end
