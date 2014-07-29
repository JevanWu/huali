class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    return unless order.kind == 'normal'
    Notify.delay.new_order_user_email(order.id)

    Analytics.track(user_id: order.user.id,
                    event: 'Placed Order',
                    properties: {
                      label: order.identifier,
                      category: 'Order'
                    },
                    context: {
                      'Google Analytics' => { clientId: order.user.ga_client_id }
                    })
  end

  def after_cancel(order, transition)
    if transition.from == "generated" && transition.to == "void"
      ApiAgentService.cancel_order(order)
    end
  end

  def after_pay(order, transition)
    Sms.delay.pay_order_user_sms(order.id)

    if order.kind == 'normal'
      Notify.delay.pay_order_user_email(order.id)
      Notify.delay.pay_order_admin_email(order.id)
    end

    Analytics.track(user_id: order.user.id,
                    event: 'Paid Order',
                    properties: {
                      label: order.identifier,
                      category: 'Order'
                    },
                    context: {
                      'Google Analytics' => { clientId: order.user.ga_client_id }
                    })
    Analytics.track(user_id: order.user.id,
                    event: 'Completed Order',
                    properties: {
                      label: order.identifier,
                      category: 'Order',
                      id: order.identifier,
                      total: order.total,
                      revenue: order.transaction.amount,
                      currency: 'CNY',
                      products: order.line_items.map { |item| { id: item.product.id, name: item.name, price: item.price, quantity: item.quantity, category: item.product_type_text } },
                      coupon_code: order.coupon_code_record.to_s,
                      province: order.province_name,
                      city: order.city_name
                    },
                    context: {
                      'Google Analytics' => { clientId: order.user.ga_client_id }
                    })
  end

  def after_check(order, transition)
    ApiAgentService.check_order(order)
    ErpWorker::ImportOrder.perform_async(order.id)
  end

  def after_ship(order, transition)
    return if order.kind == "marketing"
    Notify.delay.ship_order_user_email(order.id)
    Sms.delay.ship_order_user_sms(order.id)
    Sms.delay.ship_order_receiver_sms(order.id)

    ApiAgentService.ship_order(order)
  end

  def after_confirm(order, transition)
    Sms.delay.confirm_order_user_sms(order.id)
  end
end
