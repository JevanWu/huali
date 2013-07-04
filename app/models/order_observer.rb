class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    return unless order.type == 'normal'
    Notify.delay.new_order_user_email(order.id)
    AnalyticWorker.delay.fill_order(order.id)
  end

  def after_pay(order, transition)
    return if order.type == 'marketing'
    Sms.delay.pay_order_user_sms(order.id)
    Notify.delay.pay_order_user_email(order.id)

    # doesn't track taobao orders in GA
    return if order.type == 'taobao'
    Notify.delay.pay_order_admin_email(order.id)
    AnalyticWorker.delay.complete_order(order.id)
    GaTrackWorker.delay.order_track(order.id)
  end

  def after_ship(order, transition)
    return if order.type == "marketing"
    Notify.delay.ship_order_user_email(order.id)
    Sms.delay.ship_order_user_sms(order.id)
  end

  def after_confirm(order, transition)
    return if order.type == "marketing"
    Sms.delay.confirm_order_user_sms(order.id)
  end
end