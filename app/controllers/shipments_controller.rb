# encoding: utf-8
require 'ostruct'

class ShipmentsController < ApplicationController
  def confirm
    @shipment = Shipment.find_by_id(params[:id])
    if @shipment.accept
      redirect_to orders_path, alert: t('views.admin.shipment.shipment_state_changed') + t('models.shipment.state.completed')
    else
      redirect_to orders_path, alert: "货运订单状态更新失败"
    end
  end

  def notify
    shipment = Shipment.find_by_identifier params['identifier']
    notifier = ShipmentNotifier.new(params['param'])

    if notifier.status == "abort"
      head :not_acceptable and return
    end

    if shipment.older_than_kuaidi100_notifier(notifier)
      shipment.kuaidi100_result = notifier.data.to_json
      shipment.kuaidi100_status = notifier.state
      shipment.kuaidi100_updated_at = notifier.updated_time

      shipment.save!
    end

    render json: { result: 'true', returnCode: '200', message: '成功' }
  end
end

class ShipmentNotifier < OpenStruct
  attr_reader :updated_time, :message, :status

  def initialize(json_str)
    raw_message = JSON.parse(json_str)
    # this two messages might be useful
    @message = raw_message['message']
    @status = raw_message['status']

    # important messages is in lastResult
    super raw_message['lastResult']

    # parse formated unified time format
    @updated_time = DateTime.parse data.first['ftime'] if data.first
  end
end
