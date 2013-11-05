class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    return unless order.kind == 'normal'
    Notify.delay.new_order_user_email(order.id)
    AnalyticWorker.delay.fill_order(order.id)
  end

  def after_pay(order, transition)
    return if order.kind == 'marketing'

    order.sync_payment

    Sms.delay.pay_order_user_sms(order.id)
    Notify.delay.pay_order_user_email(order.id)

    # doesn't track non normal orders in GA
    return if order.kind != 'normal'
    Notify.delay.pay_order_admin_email(order.id)
    AnalyticWorker.delay.complete_order(order.id)
    GaTrackWorker.delay.order_track(order.id)
  end

  def after_ship(order, transition)
    return if order.kind == "marketing"
    Notify.delay.ship_order_user_email(order.id)
    Sms.delay.ship_order_user_sms(order.id)
  end

  def after_confirm(order, transition)
    return if order.kind == "marketing"
    Sms.delay.confirm_order_user_sms(order.id)
  end
end
