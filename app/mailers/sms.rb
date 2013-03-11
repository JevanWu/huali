# encoding: utf-8
require 'digest/md5'

class Sms
  ERROR_CODE = {
    '30' => '密码错误',
    '40' => '账号不存在',
    '41' => '余额不足',
    '42' => '帐号过期',
    '43' => 'IP地址限制',
    '50' => '内容含有敏感词',
    '51' => '手机号码不正确',
    '-1' => '短信发送未成功'
  }

  class << self

    def date_wait_make_order(date, *phonenums)
      orders = Order.by_state('wait_make')
                    .where('delivery_date = ?', date)

      content = <<STR
#{date.to_s}当天需要制作的订单是共有#{orders.count}:
#{orders.map(&:subject_text).join(' ')}
[花里花店] hua.li
STR

      sms(to: phonenums.join(','), content: content )
    end

    def pay_order_user_sms(order_id)
      @order = Order.full_info(order_id)

      content = <<STR
尊敬的#{@order.sender_name},订单#{@order.identifier}已经支付成功.我们将尽快为您制作发货.
[花里花店] hua.li
STR

      sms(to: @order.sender_phone, content: content )
    end

    def ship_order_user_sms(order_id)
      @order = Order.full_info(order_id)

      content = <<STR
尊敬的#{@order.sender_name},订单#{@order.identifier}已经通过#{@order.shipment.ship_method.name}发货, 编号为#{@order.shipment.tracking_num}。
[花里花店] hua.li
STR

      sms(to: @order.sender_phone, content: content)
    end

    def sms(options)
      # phone could be a joined string of phone numbers with ','
      phone = options[:to]
      content = options[:content]

      conn = Faraday.new url: 'http://www.smsbao.com' do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      response = conn.get '/sms',
        u: ENV['SMS_USERNAME'],
        p: Digest::MD5.hexdigest(ENV['SMS_PASSWORD']),
        m: phone,
        c: content

      unless response.body == '0'
        raise StandardError, ERROR_CODE[response.body] + ". " + "phone number is #{phone}"
      end
    end
  end
end
