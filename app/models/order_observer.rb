class OrderObserver < ActiveRecord::Observer

  def after_create(order)
    Notify.new_order_user_email(order.id).deliver
  end

  def after_pay(order, transition)
    Notify.pay_order_user_email(order.id).deliver
    Notify.pay_order_admin_email(order.id).deliver
  end

  def after_ship(order, transition)
    Notify.ship_order_user_email(order.id).deliver
  end
end
