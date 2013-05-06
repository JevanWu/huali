# encoding: utf-8

class Notify < ActionMailer::Base
  add_template_helper ApplicationHelper

  default from: 'support@hua.li', content_type: 'text/html', css: :email
  default_url_options[:host] = case Rails.env
                               when 'production'
                                 'hua.li'
                               when 'staging'
                                 'staging.hua.li'
                               when 'development'
                                 'hua.dev'
                               end

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

  def product_day_email(*emails)
    watched_date = ['2013-05-07', '2013-05-08', '2013-05-09', '2013-05-10', '2013-05-11']

    def product_on_day(date)
      <<-SQL
      select products.name_zh, count(line_items.quantity) as productsCount
      from orders, line_items, products
      where orders.id = line_items.order_id
      and line_items.product_id = products.id
      and orders.delivery_date = '#{date}'
      and (orders.state != 'void' and orders.state != 'generated' and orders.state != 'wait_confirm')
      group by products.name_zh
      order by productsCount desc;
      SQL
    end

    @watched_result = watched_date.map! do |date|
      result = ActiveRecord::Base.connection.execute product_on_day(date)
      { date: date, result: result.to_a }
    end

    mail(to: emails, subject: subject("#母亲节备货提醒#{Time.now}"))
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
