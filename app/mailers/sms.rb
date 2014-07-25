# encoding: utf-8
require 'digest/md5'

class Sms

  SMSBAO_ERROR_CODE = {
    '30' => '密码错误',
    '40' => '账号不存在',
    '41' => '余额不足',
    '42' => '帐号过期',
    '43' => 'IP地址限制',
    '50' => '内容含有敏感词',
    '51' => '手机号码不正确',
    '-1' => '短信发送未成功'
  }

  attr_reader :phone_number, :body, :delivery_method

  # Possible delivery_methods:
  #   :file
  #     log sms to file
  #   :sms
  #     send real sms
  def initialize(options)
    @phone_number = Phonelib.parse(options[:phone_number])
    @body = options[:body]
    @delivery_method = options[:delivery_method] ||
      Rails.configuration.sms_delivery_method
  end

  def deliver
    return unless phone_number.types.include?(:mobile)

    case delivery_method
    when :sms
      send_sms
    when :file
      log_to_file
    end
  end

  private

  def send_sms
    national? ? smsbao : twilio
  end

  def national?
    phone_number.country == Phonelib.default_country
  end

  def sanitized_national_phone
    phone_number.national.to_s.gsub(/\s/, '').sub(/^0/, '')
  end

  def smsbao
    conn = Faraday.new url: 'http://www.smsbao.com' do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.get '/sms',
      u: ENV['SMS_USERNAME'],
      p: Digest::MD5.hexdigest(ENV['SMS_PASSWORD']),
      m: sanitized_national_phone,
      c: body

    unless response.body == '0'
      raise StandardError, SMSBAO_ERROR_CODE[response.body] + ". " + "phone number is #{sanitized_national_phone}. " + "content is #{body}."
    end
  end

  def twilio
    client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

    # {
      # :to => '+16105557069',
      # :body => 'Hey there!'
    # }
    client.account.sms.messages.create(from: '+15713832992',
                                       to: phone_number.international,
                                       body: body)
  end

  def log_to_file
    log_file = File.join(Rails.root, 'log/sms.log')
    content = "Send at: #{Time.now} To: #{phone_number.international} Content: #{body}"

    a_logger = Logger.new(log_file)
    a_logger.info(content)
  end

  class << self

    def didi_passenger_coupon(didi_passenger_id)
      didi_passenger = DidiPassenger.find(didi_passenger_id)

      content = <<-STR.strip_heredoc
      恭喜您成功领取「花里」100元现金券：#{didi_passenger.coupon_code} 。您可通过「花里」官网 www.hua.li 购买喜爱的花品~
      STR

      new(phone_number: didi_passenger.phone, body: content).deliver
    end

    def date_wait_make_order(date, *phonenums)
      orders = Order.by_state('wait_make').where('delivery_date = ?', date)

      order_subject_text = orders.group_by { |o| [o.subject_text, o.ship_method.to_s] }.sort_by { |o| o.first }.map do |k, v|
        "#{k.last.slice(0, 2)}-#{k.first.sub(/\d+/, v.size.to_s)}"
      end.join

      content = <<STR.gsub(/(\s|\n)*/m, '')
#{date.to_s}当天需要制作的订单是共有#{orders.count}:
#{order_subject_text}
[花里花店] hua.li
STR

      content.scan(/.{1,128}/).each do |snippet|
        phonenums.each do |phone|
          new(phone_number: phone, body: snippet).deliver
        end
      end
    end

    def pay_order_user_sms(order_id)
      order = Order.full_info(order_id)

      content = <<STR
感谢您订购我们的花盒（#{order.identifier}）！我们的花艺师正在精心挑选花材，为您的ta定制无与伦比的惊喜「花里花店」
STR

      new(phone_number: order.sender_phone, body: content).deliver
    end

    def ship_order_user_sms(order_id)
      order = Order.full_info(order_id)

      content = <<STR
您订购的花盒（#{order.identifier}）已制作完成，我们的#{order.shipment.ship_method.name}快递师傅载着您满满的情意出发啦（快递单号：#{order.shipment.tracking_num}）「花里花店」
STR

      new(phone_number: order.sender_phone, body: content).deliver
    end

    def ship_order_receiver_sms(order_id)
      order = Order.full_info(order_id)

      content = <<STR
你有满载祝福的神秘礼物向你飞奔而来，将在这两天到达，记得查收你的美好哦「花里花店」
STR

      new(phone_number: order.address.phone, body: content).deliver
    end

    def confirm_order_user_sms(order_id)
      order = Order.full_info(order_id)

      regular_content = <<STR
您订购的花盒已被ta欣然签收，我们将永远记录这一份美好祝福「花里花店」
STR

      taobao_content = <<STR
您订购的花盒已被ta欣然签收，我们将永远记录这一份美好祝福。您的全5分好评对我们特别重要，期待您再次光临.「花里花店」
STR

      content = order.from_taobao? ? taobao_content : regular_content

      new(phone_number: order.sender_phone, body: content).deliver
    end

  end
end
