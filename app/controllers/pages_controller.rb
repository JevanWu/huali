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
    if params[:coupon_code].present? && cookies[:coupon_code] != params[:coupon_code]
      cookies[:coupon_code] = params[:coupon_code]
      flash[:notice] = "已使用现金券：#{params[:coupon_code]}, 商品总价减100元"
      flash.discard(:notice)
    end
  end

  def brands
  end

  def celebrities
  end

  def weibo_stories
  end

  def christmas
  end

  def valentine
  end

  def white_day
  end

  def pick_up
  end

  def join_us
  end

  def qixijie
  end

  def yujianli
  end

  def offline_shop
  end

end
