class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Notify.new_order_user_email(order.id).deliver
  end

  def after_pay
    Notify.pay_order_user_email(order.id).deliver
  end
end
