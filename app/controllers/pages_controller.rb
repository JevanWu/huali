class PagesController < ApplicationController

  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def partner
  end

  def home
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
    @selected_menu = :huali_point
    @point_transactions = PointTransaction.order(:created_at).page(params[:page]).per(3)
  end
end
