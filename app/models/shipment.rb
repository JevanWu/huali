# encoding: utf-8
# == Schema Information
#
# Table name: shipments
#
#  address_id           :integer
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  kuaidi100_result     :text
#  kuaidi100_status     :string(255)
#  kuaidi100_updated_at :datetime
#  note                 :text
#  order_id             :integer
#  ship_method_id       :integer
#  state                :string(255)
#  tracking_num         :string(255)
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_shipments_on_identifier      (identifier)
#  index_shipments_on_order_id        (order_id)
#  index_shipments_on_ship_method_id  (ship_method_id)
#  index_shipments_on_tracking_num    (tracking_num)
#

#
class Shipment < ActiveRecord::Base
  belongs_to :address
  belongs_to :ship_method
  belongs_to :order
  has_one :user, through: :order

  after_update :sync_with_kuaidi100_status

  before_validation :copy_address, :generate_identifier, on: :create

  validates_presence_of :order, :address, :ship_method

  validates :tracking_num, uniqueness: { scope: :ship_method_id }, allow_blank: true

  state_machine :state, initial: :ready do
    before_transition to: :shipped, do: :ship_order
    after_transition to: :completed, do: :confirm_order

    # use adj. for state with future vision
    # use v. for event namen
    state :ready do
      transition to: :shipped, on: :ship
    end

    state :shipped do
      validates_presence_of :tracking_num, if: :is_express?

      transition to: :completed, on: :accept
      transition to: :unknown, on: :mistake
    end

    state :unknown do
      transition to: :completed, on: :accept
    end
  end

  # FIXME mixed into the instance methods
  # but better be class methods
  include Rails.application.routes.url_helpers

  def self.kuaidi100_poll(shipment_id, host)

    error_code = {
      '200' => '提交成功',
      '701' => '拒绝订阅的快递公司',
      '700' => '不支持的快递公司',
      '600' => '您不是合法的订阅者',
      '500' => '服务器错误'
    }

    shipment = Shipment.find(shipment_id)

    return unless shipment.is_express?

    param = {
      company: shipment.ship_method.kuaidi_api_code,
      number: shipment.tracking_num,
      key: ENV['KUAIDI100_KEY'],
      parameters: {
        callbackurl: shipment.notify_shipment_url(shipment.identifier, host: host)
      }
    }

    conn = Faraday.new url: 'http://www.kuaidi100.com' do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    response = conn.post '/poll', schema: 'json', param: param.to_json

    # {
    #   "message" => "POLL:服务器错误",
    #   "result" => false,
    #   "returnCode" => "500"
    # }
    result = JSON.parse(response.body)

    unless result['result']
      raise StandardError, result['returnCode'] + ': ' + error_code[result['returnCode']] + ". " + "shipment_id: #{shipment_id}"
    end
  end

  def generate_identifier
    self.identifier = uid_prefixed_by('SH')
  end

  def copy_address
    self.address_id = self.order.address_id
  end

  def older_than_kuaidi100_notifier(notifier)
    kuaidi100_updated_at.nil? or kuaidi100_updated_at < notifier.updated_time
  end

  def kuai_100_url
    ship_method.kuaidi_query_code && tracking_num ? "http://www.kuaidi100.com/chaxun?com=#{ship_method.kuaidi_query_code}&nu=#{tracking_num}" : ""
  end

  def is_express?
    ship_method.method == 'express'
  end

  def is_manual?
    ship_method.method == 'manual'
  end

  private

  def sync_with_kuaidi100_status
    case kuaidi100_status
    when '2'
      mistake
    when '3'
      accept
    end
  end

  def ship_order
    self.order.ship
  end

  def confirm_order
    self.order.confirm
  end
end
