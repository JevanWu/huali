class PagesController < ApplicationController

  # caches_page :show, :home, :partner

  def show
    @page = Page.find_by_permalink!(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  def partner
  end

  def mother
    @products = Collection.find('mother').products
    render 'mother', layout: 'horizontal'
  end
end
