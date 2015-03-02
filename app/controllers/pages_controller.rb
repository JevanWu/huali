class PagesController < ApplicationController
  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def partner
  end

  def home
    @menu_nav_type = 'home'
    @slides = SlidePanel.visible
    @products = Product.published.take(3)
    @featured_products = FeaturedProduct.all
    if params[:coupon_code].present? && cookies[:coupon_code] != params[:coupon_code]
      coupon = CouponCode.find_by(code: params[:coupon_code])
      if coupon.usable?
        cookies[:coupon_code] = params[:coupon_code]
        flash[:notice] = "当前使用#{coupon.to_human}：#{params[:coupon_code]}"
      else
        flash[:notice] = "Oops, 优惠劵 #{params[:coupon_code]} 是无效的！"
      end

      flash.discard(:notice)
    end
  end

  def brands
  end

  def celebrities
  end

  def offline_shop
  end

  # def weibo_stories
  # end
  #
  # def christmas
  # end
  #
  # def valentine
  # end
  #
  # def valentine_2015
  # end
  #
  # def white_day
  # end
  #
  # def pick_up
  # end
  #
  # def join_us
  # end
  #
  # def qixijie
  # end
  #
  # def yujianli
  # end
  #
  #
  # def perfume
  # end
  #
  # def moive
  # end
  #
  # def cake_coupon
  # end
  #
  # def self_pickup
  # end
  #
  # def countdown
  # end

end
