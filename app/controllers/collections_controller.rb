class CollectionsController < ApplicationController
  # GET /collections/1
  # GET /collections/1.json
  def show
    @collection = Collection.find(params[:id])

    @products = @collection.products.available

    respond_to do |format|
      format.html { render 'show'}
      format.json { render json: @collection }
    end
  end

  def all
    @products = Product.available.all

    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: @collection }
    end
  end

end
