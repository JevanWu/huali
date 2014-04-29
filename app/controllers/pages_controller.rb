class PagesController < ApplicationController
  before_action :authenticate_user!, only: :huali_point

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

  def huali_point
    @point_transactions = current_user.point_transactions.order(:created_at).page(params[:page]).per(3)
  end
end
