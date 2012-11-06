require 'digest/md5'
require 'open-uri'
class PagesController < ApplicationController
  ALIPAY_KEY = "ux04rwiwzqbuksk0xm70u1fvmoo2p32d"
  ALIPAY_PID = "2088801670489935"
  ALIPAY_EMAIL = "tzgbusiness@gmail.com"
  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def order
    product_id = params["product_id"]
    product_wufoo_mapping = {
      "1" => 's7x2z7',
      "2" => 'x7x0k1',
      "3" => 'k7x0r9',
      "4" => 'z7p9w5'
    }
    @wufoo_id = product_wufoo_mapping[product_id]
  end

  def payment
    product_id = params["product_id"]
    @product = Product.find(product_id)
  end

  def alipay
    product_id = params["product_id"]
    order_num = Time.now.strftime("%Y%m%H%M%S")
    product = Product.find(product_id)
    options = {
      :partner => ALIPAY_PID,
      :out_trade_no => order_num,
      :total_fee => product.price.to_s,
      :seller_email => ALIPAY_EMAIL,
      :subject => product.name_cn,
      :body => product.description,
      :return_url => "http://hua.li/success?product_id=#{product_id}",
      :key => ALIPAY_KEY
    }
    redirect_to_alipay_gateway(options)
  end


  def success
  end

  private
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
