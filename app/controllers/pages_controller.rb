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

  def graduate
    @products = Product.find(72, 62, 63, 40, 42).sort.reverse
    render 'graduate', layout: 'horizontal'
  end
end
