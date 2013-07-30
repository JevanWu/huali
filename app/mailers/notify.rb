# encoding: utf-8

class Notify < ActionMailer::Base
  add_template_helper ApplicationHelper

  default from: 'support@hua.li', content_type: 'text/html', css: 'email'

  # For User
  def new_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: @order.sender_email, subject: subject("新订单", @order.subject_text))
  end

  def pay_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: @order.sender_email, subject: subject("订单付款成功", @order.subject_text))
  end

  def ship_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: [@order.sender_email, 'support@hua.li'], subject: subject("订单已发货", @order.subject_text))
  end

  # For Admin
  def pay_order_admin_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: 'support@hua.li', subject: subject("订单付款成功", @order.subject_text))
  end

  def reminder_user_email(reminder_id, *product_ids)
    @reminder = Reminder.find(reminder_id)
    @products = Product.find(product_ids)
    mail(to: @reminder.email, subject: subject('您在' + l(@reminder.created_at, format: :short) + '的提醒'))
  end

  def unpaid_orders_email
    @unpaid_orders_today = Order.unpaid_today(2)
    return if @unpaid_orders_today.blank?

    mail(to: 'support@hua.li', subject: subject("未支付订单"))
  end

  def date_summary_email(date, *emails)
    @date = date

    date_history = [date]
    6.times { |i| date_history << date.prev_day(i + 1)}

    @order_history = date_history.map do |date|
      {
        date: date,
        records: [ Order.accountable.in_day(date).count,
                  Order.accountable.in_day(date - 1.week).count,
                  Order.accountable.in_day(date - 1.month).count ]
      }
    end

    mail(to: emails, subject: subject("#{@date}的订单小结"))
  end

  def product_day_email(topic, start_date, end_date, *emails)
    @topic = topic

    @summary_products_with_count = OrderProductsOnDateQuery.summary_products(start_date, end_date)
    @summary_products_in_shanghai_with_count = OrderProductsOnDateQuery.summary_products_in_shanghai(start_date, end_date)

    @daily_products_with_count = OrderProductsOnDateQuery.daily_products(start_date, end_date)
    @daily_products_in_shanghai_with_count = OrderProductsOnDateQuery.daily_products_in_shanghai(start_date, end_date)

    mail(to: emails, subject: subject("##{@topic}备货提醒#{Time.now}"))
  end

  private

  # Examples
  #
  #   >> subject('Lorem ipsum')
  #   => "Huali | Lorem ipsum"
  #
  #   # Accepts multiple arguments
  #   >> subject('Lorem ipsum', 'Dolor sit amet')
  #   => "Huali | Lorem ipsum | Dolor sit amet"

  def subject(*extra)
    "花里花店 | " << extra.join(' | ')
  end
end
