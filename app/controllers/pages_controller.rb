# encoding: utf-8
class PagesController < ApplicationController

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
      "32" => 'z7p6m9',
      "33" => 'm7p3p7',
      "34" => 'm7p3q5',
      "35" => 'm7p2k3',
      "36" => 'm7p2s1',
      "37" => 'm7p2a9',
      "38" => 'q7p1w7',
      "39" => 'q7p1m5'
    }
    @wufoo_id = product_wufoo_mapping[@product.id.to_s]
  end

  def payment
    @product = Product.find(params[:name_en])
    # @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CEBBANK', 'SPDB', 'SHBANK', 'GDB', 'CITIC', 'CIB', 'SDB', 'CMBC', 'BJBANK', 'HZCBB2C', 'BJRCB', 'SPABANK', 'FDB', 'WZCBB2C-DEBIT', 'NBBANK', 'ICBCBTB', 'CCBBTB', SPDBB2B', 'ABCBTB']
    @banks = ['ICBCB2C', 'CMB', 'CCB', 'BOCB2C', 'ABC', 'COMM', 'CMBC']
  end

  def gateway
    product = Product.find(params[:name_en])

    product[:order_num] = generate_order_num

    delivery_fee = params[:area] == 'remote' ? 40 : 0
    cost = product.price + delivery_fee

    if params[:pay_bank] == "paypal"
      gateway = Billing::Paypal::Gateway.new paypal_options(product, cost)
      redirect_to gateway.purchase_path
    elsif params[:pay_bank] == "directPay"
      gateway = Billing::Alipay::Gateway.new alipay_options(product, cost)
      redirect_to gateway.purchase_path
    else
      gateway = Billing::Alipay::Gateway.new alipay_options(product, cost, 'bankPay', params[:pay_bank])
      redirect_to gateway.purchase_path
    end
  end

  # synchronous response from gateway
  def return
    @product = Product.find(params[:name_en])
    # r = Billing::Alipay::Return.new(request.query_string)
  end

  # asynchronous response from gateway
  def notify
    # notification = Billing::Alipay::Notification.new(request.raw_post)
  end

  def share
  end

  def partner
  end

  private

  def generate_order_num
    Time.now.strftime("%Y%m%H%M%S")
  end

  def paypal_options(product, cost)
    {
      'item_name' => product.name,
      'amount' => exchange_to_dollar(cost)
    }
  end

  def alipay_options(product, cost, method = 'directPay', bank = '')
    options = {
      'out_trade_no' => product[:order_num],
      'total_fee' => cost.to_s,
      'paymethod' => method,
      'defaultbank' => bank,
      'subject' => product.name,
      'body' => product.description[0..50],
      'return_url' => success_url(product),
      'show_url' => product_url(product)
    }
  end

  def exchange_to_dollar(price)
    amount = (price/6).to_i - 0.01
    amount.to_s
  end

end
