class PagesController < ApplicationController

  ALIPAY_KEY = "ux04rwiwzqbuksk0xm70u1fvmoo2p32d"
  ALIPAY_PID = "2088801670489935"
  ALIPAY_EMAIL = "tzgbusiness@gmail.com"
  PAYPAL_EMAIL = "s@zenhacks.org"
  #caches_page :show, :home, :order, :payment, :alipay, :success
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
      "29" => 'z7p6p1',
      "30" => 'm7p4w1',
      "31" => 'm7p5a3',
      "32" => 'z7p6m9'
    }
    @wufoo_id = product_wufoo_mapping[@product.id.to_s]
  end

  def payment
    @product = Product.find(params[:name_en])
    @product[:us_price] = exchange_to_dollar @product.price
    # @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CEBBANK', 'SPDB', 'SHBANK', 'GDB', 'CITIC', 'CIB', 'SDB', 'CMBC', 'BJBANK', 'HZCBB2C', 'BJRCB', 'SPABANK', 'FDB', 'WZCBB2C-DEBIT', 'NBBANK', 'ICBCBTB', 'CCBBTB', SPDBB2B', 'ABCBTB']
    @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CMBC']
  end

  def gateway
    if params[:pay_bank] == "paypal"
      redirect_to Transaction.paypal_gateway(query_hash(params))
    elsif params[:pay_bank] == "directPay"
      params[:paymethod] = "directPay"
      redirect_to Transaction.alipay_gateway(query_hash(params))
    else
      params[:paymethod] = "bankPay"
      params[:defaultbank] = params[:pay_bank]
      redirect_to Transaction.alipay_gateway(query_hash(params))
    end
  end

  def success
    @product = Product.find(params[:name_en])
  end

  private
  def query_hash(param={})
    order_num = Time.now.strftime("%Y%m%H%M%S")
    product = Product.find(params[:name_en])

    delivery_fee = params[:area] == 'remote' ? 50 : 0
    total_cost = product.price + delivery_fee

    query_hash = {
      :key => ALIPAY_KEY,
      :partner => ALIPAY_PID,
      :out_trade_no => order_num,
      :total_fee => total_cost.to_s,
      :payment_type => "1",
      :paymethod => "directPay",
      :"_input_charset" => 'utf-8',
      :service => "create_direct_pay_by_user",
      :seller_email => ALIPAY_EMAIL,
      :subject => product.name_zh,
      :body => product.description,
      :return_url => "http://hua.li/success/#{product.id}"
     }
    if params[:paymethod] == "directPay"
      query_hash
    elsif params[:paymethod] == "bankPay"
      query_hash[:paymethod] = "bankPay"
      query_hash[:defaultbank] = params[:defaultbank]
      query_hash
    else
      query_hash = {
        :item_name => product.name_en,
        :amount => exchange_to_dollar(total_cost).to_s,
        :paypal_email => PAYPAL_EMAIL
      }
    end
  end

  def exchange_to_dollar(price)
    (price/6).to_i - 0.01
  end

end
