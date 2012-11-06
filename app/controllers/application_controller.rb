require 'digest/md5'
require 'open-uri'
class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.application.config.consider_all_requests_local

    rescue_from 'Exception' do |exception|
      render_error 500, exception
    end

    rescue_from 'ActionController::RoutingError', 'ActionController::UnknownController', '::AbstractController::ActionNotFound', 'ActiveRecord::RecordNotFound' do |exception|
      render_error 404, exception
    end

  end

  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def redirect_to_alipay_gateway(options={})
    query_string = {
      :partner => options[:partner],
      :out_trade_no => options[:out_trade_no],
      :total_fee => options[:total_fee],
      :seller_email => options[:seller_email],
      :return_url => options[:return_url],
      :body => options[:body],
      :"_input_charset" => 'utf-8',
      :service => "create_direct_pay_by_user",
      :payment_type => "1",
      :subject => options[:subject]
    }.sort.map do |key, value|
      "#{key}=#{URI::encode(value)}" 
      end.join("&")
    sign = Digest::MD5.hexdigest(query_string + options[:key])
    query_string += "&sign=#{sign}&sign_type=MD5"
    redirect_to "https://www.alipay.com/cooperate/gateway.do?" + query_string
  end

end
