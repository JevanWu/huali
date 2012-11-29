class ProductsController < ApplicationController
  caches_page :show
  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    assets  = @product.assets || []

    # filter empty assets
    assets.compact!

    @asset_urls = assets.map do |asset|
      {
        :full => asset.image.url,
        :medium => asset.image.url(:medium),
        :thumb => asset.image.url(:thumb)
      }
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
end
