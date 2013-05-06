# encoding: utf-8
class ShipmentsController < ApplicationController
  def kuaidi100_notify
    render json: {result: 'true', returnCode: '200', message: '成功'}

    identifier = CGI.parse(request.query_string)['identifier'].first
    kuaidi100_notifier = Kuaidi100Notifier.new(identifier, request.raw_post)
    kuaidi100_notifier.update_shipment if kuaidi100_notifier.need_update?
  end
end

class Kuaidi100Notifier
  attr_reader :update_time, :status, :need_update

  def initialize(identifier, raw_post)
    # parsing
    @shipment = Shipment.find_by_identifier(identifier)
    post = JSON.parse URI.unescape(raw_post).sub('param=','')
    @last_result = post['lastResult']
    @status = @last_result['state'].to_i
    @updated_time = DateTime.parse(@last_result['data'][0]['ftime'])
  end

  def update_shipment
    @shipment.kuaidi100_result = @last_result.to_json
    @shipment.kuaidi100_status = @status
    @shipment.kuaidi100_updated_at = @updated_time
    @shipment.save

    case @status
    when 0,1
      @shipment.ship
    when 2
      @shipment.got_unknown_status
    when 3
      @shipment.accept
    end
  end

  def need_update?
    @updated_time > @shipment.kuaidi100_updated_at
  end
end
