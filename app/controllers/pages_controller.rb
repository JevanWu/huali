require 'digest/md5'
require 'open-uri'
class PagesController < ApplicationController
  caches_page :show, :home, :order, :payment, :alipay, :success
  ALIPAY_KEY = "ux04rwiwzqbuksk0xm70u1fvmoo2p32d"
  ALIPAY_PID = "2088801670489935"
  ALIPAY_EMAIL = "tzgbusiness@gmail.com"
  PAYPAL_EMAIL = "s@zenhacks.org"
  PAYPAL_HOST = "www.paypal.com"
  #host = ActiveMerchant::Billing::Base.mode == "test" ? "www.sandbox.paypal.com" : "www.paypal.com"
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
    @product[:us_price] = exchange_to_dollar @product.price
    # @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CEBBANK', 'SPDB', 'SHBANK', 'GDB', 'CITIC', 'CIB', 'SDB', 'CMBC', 'BJBANK', 'HZCBB2C', 'BJRCB', 'SPABANK', 'FDB', 'WZCBB2C-DEBIT', 'NBBANK', 'ICBCBTB', 'CCBBTB', SPDBB2B', 'ABCBTB']
    @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CMBC']
  end

  def alipay
    order_num = Time.now.strftime("%Y%m%H%M%S")
    product = Product.find(params[:name_en])
    options = {
      :item_name => product.name_en,
      :amount => exchange_to_dollar(product.price).to_s,
      :partner => ALIPAY_PID,
      :out_trade_no => order_num,
      :total_fee => product.price.to_s,
      :payment_type => "1",
      :seller_email => ALIPAY_EMAIL,
      :subject => product.name_zh,
      :body => product.description,
      :return_url => "http://hua.li/success/#{product.id}",
      :key => ALIPAY_KEY
     }
    if params[:pay_bank] == "paypal"
      redirect_to_paypal_gateway(options)
    elsif params[:pay_bank] == "directPay"
      paymethod = "directPay"
      options[:paymethod] = paymethod
      redirect_to_alipay_gateway(options)
    else
      paymethod = "bankPay"
      defaultbank = params[:pay_bank]
      options[:paymethod] = paymethod
      options[:defaultbank] = defaultbank
      redirect_to_alipay_gateway(options)
    end
  end


  def success
    @product = Product.find(params[:name_en])
  end

  private
  def exchange_to_dollar(price)
    (price/6).to_i - 0.01
  end

  def redirect_to_alipay_gateway(options={})
    query_string = {
      :partner => options[:partner],
      :out_trade_no => options[:out_trade_no],
      :total_fee => options[:total_fee],
      :seller_email => options[:seller_email],
      :return_url => options[:return_url],
      :paymethod => options[:paymethod],
      :"_input_charset" => 'utf-8',
      :service => "create_direct_pay_by_user",
      :payment_type => "1",
      :subject => options[:subject]
    }
    if options[:defaultbank]
      query_string[:defaultbank] = options[:defaultbank]
    end
    query_string = query_string.sort.map do |key, value|
        "#{key}=#{value}"
        end.join("&")
    sign = Digest::MD5.hexdigest(query_string + options[:key])
    query_string += "&sign=#{sign}&sign_type=MD5"
    query_string = URI::encode(query_string)
    redirect_to "https://www.alipay.com/cooperate/gateway.do?" + query_string
  end


  def redirect_to_paypal_gateway(options={})
    redirect_to URI.encode("https://#{PAYPAL_HOST}/cgi-bin/webscr?cmd=_ext-enter&redirect_cmd=_xclick&charset=utf-8&business=#{PAYPAL_EMAIL}&currenct_code=USD&item_name=#{options[:item_name]}&amount=#{options[:amount]}" )
  end
end
