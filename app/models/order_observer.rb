class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    return unless order.kind == 'normal'
    Notify.delay.new_order_user_email(order.id)
    AnalyticWorker.delay.fill_order(order.id)
  end

  def after_cancel(order, transition)
    if transition.from == "generated" && transition.to == "void"
      ApiAgentService.cancel_order(order)
    end
  end

  def after_pay(order, transition)
    Sms.delay.pay_order_user_sms(order.id)
    Notify.delay.pay_order_user_email(order.id)

    Notify.delay.pay_order_admin_email(order.id)
    AnalyticWorker.delay.complete_order(order.id)
    GaTrackWorker.delay.order_track(order.id)
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
