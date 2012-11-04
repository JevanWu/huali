class PagesController < ApplicationController
  caches_page :order
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
    @wufoo_id = 's7x2z7'
  end

end