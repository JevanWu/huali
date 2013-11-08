class ProductsController < ApplicationController
  def show
    @product = Product.published.find(params[:id])

    # FIXME products always have assets now
    assets  = @product.assets || []

    # filter empty assets
    assets.compact!

    @asset_urls = assets.map do |asset|
      {
        full: asset.image.url,
        medium: asset.image.url(:medium),
        small: asset.image.url(:small),
        thumb: asset.image.url(:thumb)
      }
    end

    # suggestion
    @related_products = @product.related_products

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  def index
    @collection = Collection.available.find(params[:collection_id])

    @products = Product.published.joins(:collections).
      where("collections_products.collection_id in (?)",
            @collection.self_and_descendants.map(&:id)).uniq.page(params[:page])

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @products }
    end
  end

  def tagged_with
    @collection = Collection.available.find(params[:collection_id])

    collection_ids = @collection.self_and_descendants.map(&:id)
    @products = Product.published.joins(:collections).
      where("collections_products.collection_id in (?)", collection_ids).
      tagged_with(params[:tags], on: :tags).
      uniq.page(params[:page])

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @products }
    end
  end
end
