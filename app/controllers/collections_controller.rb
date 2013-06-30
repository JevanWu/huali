class CollectionsController < ApplicationController
  def show
    @collection = Collection.available.find(params[:id])

    @products = @collection.products.published

    respond_to do |format|
      format.html { render 'show'}
      format.json { render json: @collection }
    end
  end
end
