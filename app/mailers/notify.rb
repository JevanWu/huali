# encoding: utf-8

class Notify < ActionMailer::Base
  add_template_helper ApplicationHelper
  #after_action :set_emailcar_header

  default from: 'support@hua.li', content_type: 'text/html', css: 'email'

  # For User
  def new_order_user_email(order_id)
    @order = Order.full_info(order_id)
    return if @order.nil? || @order.sender_email.blank?

    mail(to: @order.sender_email, subject: subject("新订单", @order.subject_text))
  end

  def pay_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: @order.sender_email, subject: subject("订单付款成功", @order.subject_text))
  end

  def ship_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: [@order.sender_email], subject: subject("订单已发货", @order.subject_text))
  end

  # For Admin
  def pay_order_admin_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: 'order@hua.li', subject: subject("订单付款成功", @order.subject_text))
  end

  def reminder_user_email(reminder_id, *product_ids)
    @reminder = Reminder.find(reminder_id)
    @products = Product.find(product_ids)
    mail(to: @reminder.email, subject: subject('您在' + l(@reminder.created_at, format: :short) + '的提醒'))
  end

  def ready_to_ship_orders_today(date, *emails)
    @ready_to_ship_orders_today = Order.ready_to_ship_today(date)
    return if @ready_to_ship_orders_today.blank?


    columns = ["订单号", "收件人", "联系方式", "省份", "快递方式", "产品", "发货日期", "来源"]
    row_data = @ready_to_ship_orders_today.map do |o|
      [o.identifier, o.address.fullname, o.address.phone, o.address.province_name, o.ship_method, o.subject_text, o.delivery_date, o.source]
    end

    attachments['回访订单.xlsx'] = XlsxBuilder.new(columns, row_data).serialize
    mail(to: emails, subject: subject("回访订单"))
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

  def product_day_email_wait_delivery(topic, start_date, end_date, *emails)
    @topic = topic
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    @days = (@start_date..@end_date).to_a.size

    @summary_products_with_count = OrderProductsOnDateQuery
                                    .wait_delivery
                                    .summary_products(@start_date, @end_date)

    @summary_products_manual_with_count = OrderProductsOnDateQuery
                                    .wait_delivery
                                    .summary_products_manual(@start_date, @end_date)

    @daily_products_with_count = OrderProductsOnDateQuery
                                  .wait_delivery
                                  .daily_products(@start_date, @end_date)

    @daily_products_manual_with_count = OrderProductsOnDateQuery
                                  .wait_delivery
                                  .daily_products_manual(@start_date, @end_date)

    mail(to: emails, subject: subject("##{@topic}#备货提醒#{Time.now}"))
  end

  def product_day_email_delivered(topic, start_date, end_date, *emails)
    @topic = topic
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    @days = (@start_date..@end_date).to_a.size

    @summary_products_with_count = OrderProductsOnDateQuery
                                    .delivered
                                    .summary_products(@start_date, @end_date)

    @summary_products_manual_with_count = OrderProductsOnDateQuery
                                    .delivered
                                    .summary_products_manual(@start_date, @end_date)

    @daily_products_with_count = OrderProductsOnDateQuery
                                  .delivered
                                  .daily_products(@start_date, @end_date)

    @daily_products_manual_with_count = OrderProductsOnDateQuery
                                  .delivered
                                  .daily_products_manual(@start_date, @end_date)

    mail(to: emails, subject: subject("##{@topic}#已经发货备忘#{Time.now}"))
  end

  def date_wait_make_order_email(date, *emails)
    orders = Order.by_state('wait_make').where('delivery_date = ?', date)

    order_subject_text = orders.group_by { |o| [o.subject_text, o.ship_method.to_s] }.sort_by { |o| o.first }.map do |k, v|
      "#{k.last.slice(0, 2)}-#{k.first.sub(/\d+/, v.size.to_s)}"
    end.join

    @content = <<STR
#{date.to_s}当天需要制作的订单是共有#{orders.count}:
#{order_subject_text}
[花里花店] hua.li
STR

    mail(to: emails, subject: subject("#{date} 等待制作订单"))
  end

  def api_shipping_failed_orders(*emails)
    require 'sidekiq'

    query = Sidekiq::RetrySet.new
    jobs = query.select do |job|
      job.item['args'].any? { |a| a.to_s.include?(":ship_order") }
    end

    @orders = jobs.map { |job| job.item['args'].first.scan(/\d{15}/).first }.uniq
    return if @orders.blank?

    jobs.map(&:delete)

    mail(to: emails, subject: subject("淘宝/天猫自动发货失败订单, 请人工处理"))
  end

  def all_orders_excel_email(*emails)
    columns = Order.column_names.map(&:titleize)
    row_data = Order.all.to_a.map { |o| o.attributes.values }

    attachments["所有订单 #{Date.current}.xlsx"] = XlsxBuilder.new(columns, row_data).serialize
    mail(to: emails, subject: subject("所有订单 #{Date.current}"))
  end

  def invite_message(from, resource, subject)
    @resource = resource
    @token = @resource.raw_invitation_token

    mail(from: from, to: @resource.email, subject: subject, template_path: 'devise/mailer', template_name: 'invitation_instructions')
  end

  def sales_report(average_order_amount, amount_chart_image_url, count_chart_image_url, *emails)
    @amount_chart_image_url = amount_chart_image_url
    @count_chart_image_url = count_chart_image_url
    @average_order_amount = average_order_amount

    mail(to: emails, subject: subject("Sales Report - #{Date.current}"))
  end

  def wechat_warning(@warning, *emails)
    mail(to: emails, subject: subject("Wechat Order Warning"))
  end

  helper MailerHelper

private

  def set_emailcar_header
    headers["X-Scedm-Tid"] = "#{ENV["EMAILCAR_SMTP_USERNAME"]}.#{Time.current.to_i}"
  end

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
