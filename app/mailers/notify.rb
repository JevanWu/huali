# encoding: utf-8

class Notify < ActionMailer::Base
  include Resque::Mailer
  add_template_helper ApplicationHelper

  default_url_options[:host] = 'hua.li'
  default from: 'info@hua.li'

  #
  # Order
  #

  def new_order_user_email(order_id)
    @order = Order.full_info(order_id)
    mail(to: 's@zenhacks.org', subject: subject("新订单", @order.subject_text))
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
    "Huali | " << extra.join(' | ')
  end
end
