class CollectionsController < ApplicationController
  def show
    @collection = Collection.available.find(params[:id])

    @products = Product.published.joins(:collections).
      where("collections_products.collection_id in (?)",
            @collection.self_and_descendants.map(&:id)).page(params[:page])

    respond_to do |format|
      format.html { render 'show'}
      format.json { render json: @collection }
    end
  end
end
