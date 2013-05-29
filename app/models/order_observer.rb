class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    Notify.delay.new_order_user_email(order.id)
    AnalyticWorker.delay.fill_order(order.id)
  end

  def after_pay(order, transition)
    Notify.delay.pay_order_user_email(order.id)
    Notify.delay.pay_order_admin_email(order.id)
    Sms.delay.pay_order_user_sms(order.id)
    AnalyticWorker.delay.complete_order(order.id)
  end

  def after_ship(order, transition)
    Notify.delay.ship_order_user_email(order.id)
    Sms.delay.ship_order_user_sms(order.id)
  end

  def after_confirm(order, transition)
    Sms.delay.confirm_order_user_sms(order.id)
  end
end
