# encoding: utf-8
class ShipmentsController < ApplicationController
  def kuaidi100_notify
    File.open('kuaidi100_notify.out', 'a') { |file| file.write("query_string\n"+request.query_string+"\nraw_post"+request.raw_post+"\n") }
    render json: {result: 'true', returnCode: '200', message: '成功'}

    identifier = CGI.parse(query_string)['identifier'].first
    shipment = Shipment.where(identifier: identifier).first

    kuaidi100_notifier = Kuaidi100Notifier.new(shipment, request.raw_post)
    return if updated_time < shipment.kuaidi100_notifier.updated_time
    kuaidi100_notifier.update_shipment
  end
end

class Kuaidi100Notifier
  attr_reader :update_time, :status

  def initialize(@shipment, raw_post)
    # parsing
    post = JSON.parse URI.unescape(raw_post).sub('param=','')
    @last_result = post['lastResult']
    @status = last_result['state']
    @updated_time = DateTime.parse(last_result['data'][0]['ftime'])
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
end
