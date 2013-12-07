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
  end

  def brands
  end

  def celebrities
  end

  def weibo_stories
  end

  def christmas
  end
end
