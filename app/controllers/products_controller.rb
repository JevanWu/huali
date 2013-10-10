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
end
