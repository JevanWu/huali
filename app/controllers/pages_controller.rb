class PagesController < ApplicationController
  ALIPAY_KEY = "ux04rwiwzqbuksk0xm70u1fvmoo2p32d"
  ALIPAY_PID = "2088801670489935"
  ALIPAY_EMAIL = "tzgbusiness@gmail.com"
  caches_page :order
  caches_page :payment
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
    product_wufoo_mapping = { "1" => 's7x2z7' }
    @wufoo_id = product_wufoo_mapping[product_id]
  end


  def payment
    product_id = params["product_id"]
    @product = Product.find(product_id)
  end

  def alipay
    product_id = params["product_id"]
    product = Product.find(product_id)
    options = { 
      :partner => ALIPAY_PID,
      :out_trade_no =>"10002", 
      :total_fee => product.price.to_s, 
      :seller_email => ALIPAY_EMAIL,
      :subject => product.name_cn,
      :body => product.description, 
      :return_url => "http://localhost:3000/",
      #:return_url => "http://www.baidu.com",
      :key => ALIPAY_KEY
    }
    redirect_to_alipay_gateway(options)
  end
end
