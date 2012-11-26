require 'digest/md5'
require 'open-uri'
class PagesController < ApplicationController
  caches_page :show, :home, :order, :payment, :alipay, :success
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

  def home
  end

  def order
    name_en = params["name_en"]
    @product = Product.find(params[:name_en])
    product_wufoo_mapping = {
      "22" => 's7x2z7',
      "23" => 'z7p9m3',
      "24" => 'z7p8x1',
      "25" => 'z7p8q9',
      "26" => 'z7p7k7',
      "27" => 'z7p7s5',
      "28" => 'z7p7z3',
      "29" => 'z7p6p1'
    }
    @wufoo_id = product_wufoo_mapping[@product.id.to_s]
  end

  def payment
    @product = Product.find(params[:name_en])
  end

  def alipay
    if params[:pay_bank] == "directPay"
      paymethod = "directPay"
    else
      paymethod = "bankPay"
      defaultbank = params[:pay_bank]
    end
    order_num = Time.now.strftime("%Y%m%H%M%S")
    product = Product.find(params[:name_en])
    options = {
      :partner => ALIPAY_PID,
      :out_trade_no => order_num,
      :defaultbank => defaultbank,
      :paymethod => paymethod,
      :total_fee => product.price.to_s,
      :payment_type => "1",
      :seller_email => ALIPAY_EMAIL,
      :subject => product.name_cn,
      :body => product.description,
      :return_url => "http://hua.li/success/#{product.id}",
      :key => ALIPAY_KEY
    }
    redirect_to_alipay_gateway(options)
  end


  def success
    @product = Product.find(params[:name_en])
  end

  private
  def redirect_to_alipay_gateway(options={})
    query_string = {
      :partner => options[:partner],
      :out_trade_no => options[:out_trade_no],
      :total_fee => options[:total_fee],
      :seller_email => options[:seller_email],
      :return_url => options[:return_url],
      :defaultbank => options[:defaultbank],
      :paymethod => options[:paymethod],
      :"_input_charset" => 'utf-8',
      :service => "create_direct_pay_by_user",
      :payment_type => "1",
      :subject => options[:subject]
    }.sort.map do |key, value|
      "#{key}=#{value}"
      end.join("&")
    sign = Digest::MD5.hexdigest(query_string + options[:key])
    query_string += "&sign=#{sign}&sign_type=MD5"
    query_string = URI::encode(query_string)
    redirect_to "https://www.alipay.com/cooperate/gateway.do?" + query_string
  end
end
