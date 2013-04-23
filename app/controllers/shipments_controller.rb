# encoding: utf-8
class ShipmentsController < ApplicationController
  def kuaidi100_notify
    File.open('kuaidi100_notify.out', 'a') { |file| file.write("query_string\n"+request.query_string+"\nraw_post"+request.raw_post+"\n") }
    render json: {result: 'true', returnCode: '200', message: '成功'}

    identifier = CGI.parse(request.query_string)['identifier'].first
    shipment = Shipment.where(identifier: identifier).first
    jsonPost = JSON.parse URI.unescape(request.raw_post).sub('param=','')
    status = jsonPost['lastResult']['state']

    shipment.kuaidi100_result = jsonPost['lastResult'].to_json
    shipment.kuaidi100_status = status
    shipment.save

    
    end
end
