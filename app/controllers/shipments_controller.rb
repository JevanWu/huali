# encoding: utf-8
class ShipmentsController < ApplicationController
  def kuaidi100_notify
    File.open('kuaidi100_notify.out', 'a') { |file| file.write("query_string\n"+request.query_string+"\nraw_post"+request.raw_post+"\n") }
    render json: {result: 'true', returnCode: '200', message: '成功'}

    identifier = CGI.parse(request.query_string)['identifier'].first
    shipment = Shipment.where(identifier: identifier).first
    post = JSON.parse URI.unescape(request.raw_post).sub('param=','')
    lastResult = post['lastResult']
    status = lastResult['state']
    latestUpdatedTime = DateTime.parse(lastResult['data'][0]['ftime'])

    return if latestUpdatedTime < shipment.kuaidi100_updated_at

    shipment.kuaidi100_result = lastResult.to_json
    shipment.kuaidi100_status = status
    shipment.kuaidi100_updated_at = latestUpdatedTime
    shipment.save

    case status
    when 0,1
      shipment.ship
    when 2
      shipment.got_unknown_status
    when 3
      shipment.accept
    end
  end
end
