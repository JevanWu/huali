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
      :return_url => "http://www.changanflowers.com",
      :key => ALIPAY_KEY
    }
    redirect_to_alipay_gateway(options)
  end
end
